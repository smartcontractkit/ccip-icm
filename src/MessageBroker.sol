// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CCIPReceiver} from "src/ccip/CCIPReceiver.sol";
import {Client} from "src/ccip/Client.sol";
import {Withdraw} from "./utils/Withdraw.sol";
import {ITeleporterMessenger, TeleporterFeeInfo, TeleporterMessageInput} from "@teleporter/TeleporterMessenger.sol";

contract MessageBroker is CCIPReceiver, Withdraw {

    // struct to hold details of a message.
    struct Message {
        bytes32 messageID;
        uint64 sourceChainSelector;
        address sender;
        string message;
    }

    // CCIP | Receiver Variables
    bytes32 public latestMessageId;
    bytes32 public latestBrokeredId;

    // ICM | Broker Variables
    uint64 public latestSourceChainSelector;
    address public latestSender;
    string public latestMessageText;
    address public routerAddress;

    // HYBRID | Broker Variables
    bytes32[] public receivedMessages;                  // IDs of received messages.
    bytes32[] public brokeredMessages;                  // IDs of brokered messages.
    mapping(bytes32 => Message) public messageDetail;   // messageID -> Message struct mapping.

    ITeleporterMessenger public immutable teleporterMessenger =
        ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);

    event MessageReceived(
        bytes32 latestMessageId, uint64 latestSourceChainSelector, address latestSender, string latestMessage
    );
 
    modifier brokerReady() {
        uint totalReceived = receivedMessages.length;
        uint totalBrokered = brokeredMessages.length;
        require(totalReceived > totalBrokered, "MessageBroker: no pending messages");
        _;
    }

    constructor(address _routerAddress) CCIPReceiver(_routerAddress) {
        routerAddress = _routerAddress;
    }

    // sends: message from broker -> receiver.
    function brokerMessage(
        address _destinationAddress
    ) public brokerReady returns (bytes32) {
        latestBrokeredId = teleporterMessenger.sendCrossChainMessage(TeleporterMessageInput({
            destinationBlockchainID: 0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7,
            destinationAddress: _destinationAddress,
            feeInfo: TeleporterFeeInfo({feeTokenAddress: address(0), amount: 0}),
            requiredGasLimit: 1e6,
            allowedRelayerAddresses: new address[](0),
            message: abi.encode(latestMessageText)
        }));

        brokeredMessages.push(latestBrokeredId);

        return latestBrokeredId;
    }

    function getLatestMessageDetails() public view returns (bytes32, uint64, address, string memory) {
        return (latestMessageId, latestSourceChainSelector, latestSender, latestMessageText);
    }

    function getFeeInfo() public pure returns (TeleporterFeeInfo memory) {
        return TeleporterFeeInfo({feeTokenAddress: address(0), amount: 0});
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        require(message.messageId != latestMessageId, "MessageBroker: message already received");

        latestMessageId = message.messageId;
        latestSourceChainSelector = message.sourceChainSelector;
        latestSender = abi.decode(message.sender, (address));
        latestMessageText = abi.decode(message.data, (string));

        // updates: state variables and mapping.
        receivedMessages.push(message.messageId);
        Message memory detail = Message(
            latestMessageId,
            latestSourceChainSelector,
            latestSender,
            latestMessageText
        );
        messageDetail[latestMessageId] = detail;

        emit MessageReceived(latestMessageId, latestSourceChainSelector, latestSender, latestMessageText);
    }
}
