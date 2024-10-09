// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BaseScript, console} from "./BaseScript.s.sol";
import {MessageReceiver} from "../src/MessageReceiver.sol";

contract ReceiveMessage is BaseScript {
    MessageReceiver messageReceiver = MessageReceiver(MESSAGE_RECEIVER_ADDRESS);
    
    function run(
        string memory messageText
    ) external {
        vm.startBroadcast(PRIVATE_KEY);
        messageReceiver.receiveTeleporterMessage(
            DISPATCH_BLOCKCHAIN_ID, 
            MESSAGE_BROKER_ADDRESS, 
            abi.encode(messageText)
        );

        string memory lastMessage = messageReceiver.lastMessageReceived();
        console.log('Last Message Received: \'%s\'', lastMessage);
        vm.stopBroadcast();
    }
}