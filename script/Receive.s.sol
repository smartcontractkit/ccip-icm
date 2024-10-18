// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BaseScript, console} from "./BaseScript.s.sol";
import {MessageReceiver} from "../src/MessageReceiver.sol";

contract ReceiveMessage is BaseScript {
    MessageReceiver messageReceiver = MessageReceiver(MESSAGE_RECEIVER_ADDRESS);
    
    function run(
    ) external {
        vm.startBroadcast(PRIVATE_KEY);
        string memory lastMessageReceived = messageReceiver.lastMessageReceived();
        console.log('Last Message Received: \'%s\'', lastMessageReceived);
        vm.stopBroadcast();
    }
}