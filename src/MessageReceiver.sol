// (c) 2023, Ava Labs, Inc. All rights reserved.
// See the file LICENSE for licensing terms.

// SPDX-License-Identifier: Ecosystem

pragma solidity ^0.8.19;

import {ITeleporterMessenger} from "src/icm/ITeleporterMessenger.sol";
import {ITeleporterReceiver} from "src/icm/ITeleporterReceiver.sol";

contract MessageReceiver is ITeleporterReceiver {
    struct Message {
        address sender;
        string message;
    }

  	mapping(bytes32 => Message) private messages;
    error Unauthorized();

    ITeleporterMessenger public teleporterMessenger; 

    receive() external payable {}

    string public lastMessageReceived;

    constructor(address _teleporterMessenger) {
        teleporterMessenger = ITeleporterMessenger(_teleporterMessenger);
    }

    function receiveTeleporterMessage(
        bytes32 originChainID,
        address originSenderAddress,
        bytes calldata message
    ) external {
      	// Only Interchain Messaging receiver can deliver a message.
        if (msg.sender != address(teleporterMessenger)) {
            revert Unauthorized();
        }
        lastMessageReceived = abi.decode(message, (string));
        messages[originChainID] = Message(originSenderAddress, lastMessageReceived);
    }
}
