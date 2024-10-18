// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {console, Setup} from "./Setup.t.sol";
import {Client} from "src/ccip/Client.sol";
import {IWarpMessenger} from "src/icm/IWarpMessenger.sol";

contract Enchanted is Setup {
    
    function setUp() public override {
        Setup.setUp();

        vm.selectFork(fujiFork);
        vm.mockCall(
            WARP_PRECOMPILE_ADDRESS,
            abi.encodeWithSelector(IWarpMessenger.getBlockchainID.selector),
            abi.encode(DISPATCH_BLOCKCHAIN_ID)
        );
    }

    // HELPER FUNCTIONS //

    // SENDER | sends: Sender -> Broker Contract
    function _send(string memory _messageText) internal returns (
        uint256 _chainId, bytes32 _sentMessageId, string memory _textSent) {
        console.log("\u231B | Sending \'%s\'", _messageText);

        vm.selectFork(sepoliaFork);
        _chainId = block.chainid;

        _sentMessageId = messageSender.send(FUJI_CHAIN_SELECTOR, MESSAGE_BROKER_ADDRESS, _messageText);

        _textSent = messageSender.latestText();
    }

    // BROKER | reads: `latestMessageText` from MessageBroker
    function _intercept() public returns (uint256 _chainId, string memory _messageIntercepted) {
        console.log("\u231B | Intercepting...");
        ccipLocalSimulatorFork.switchChainAndRouteMessage(fujiFork);
        _chainId = block.chainid;

        _messageIntercepted = messageBroker.latestMessageText();
    }

    // BROKER | brokers: Fuji -> Dispatch
    function _broker(string memory _messageText) public returns (
        uint256 _fromChain, bytes32 _brokerMessageId, string memory _messageBrokered) {
        console.log("\u231B | Brokering \'%s\'", _messageText);

        vm.selectFork(fujiFork);
        _fromChain = block.chainid;

        vm.mockCall(
            WARP_PRECOMPILE_ADDRESS, abi.encode(IWarpMessenger.sendWarpMessage.selector), abi.encode(bytes32(0))
        );

        console.log('\u231B | Brokering Message to Dispatch...');

        _brokerMessageId = messageBroker.brokerMessage(
            MESSAGE_RECEIVER_ADDRESS // _destinationAddress
        );

        _messageBrokered = messageBroker.latestMessageText();
    }

    // RECEIEVER | reads: `lastMessageReceived` from MessageReceiver
    function _receive() public returns (uint256 _toChain, string memory _lastMessage) {
        console.log("\u231B | Receiving...");

        vm.selectFork(dispatchFork);
        _toChain = block.chainid;

        vm.mockCall(
            WARP_PRECOMPILE_ADDRESS, abi.encode(IWarpMessenger.sendWarpMessage.selector), abi.encode(bytes32(0))
        );

        vm.prank(TELEPORTER_MESSENGER_ADDRESS);
        messageReceiver.receiveTeleporterMessage(
            DISPATCH_BLOCKCHAIN_ID, MESSAGE_BROKER_ADDRESS, abi.encode(messageText)
        );

        _lastMessage = messageReceiver.lastMessageReceived();
    }

    // ENCHANTMENTS //

    // creates: message to send cross-chain [TODO]
    function createMessage(Client.EVMTokenAmount[] memory tokensToSendDetails) public view returns (
        Client.EVM2AnyMessage memory message) {
        message = Client.EVM2AnyMessage({
            receiver: abi.encode(MESSAGE_BROKER_ADDRESS),
            data: abi.encode(messageText),
            tokenAmounts: tokensToSendDetails,
            extraArgs: Client._argsToBytes(Client.EVMExtraArgsV1({gasLimit: 200_000})),
            feeToken: address(0)
        });
    }
}
