// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BaseScript, console} from "./BaseScript.s.sol";

import {MessageSender} from "../src/MessageSender.sol";
import {MessageReceiver} from "../src/MessageReceiver.sol";

contract SendMessage is BaseScript {
    MessageSender messageSender = MessageSender(MESSAGE_SENDER_ADDRESS);

    function run(string memory messageText) external {

        vm.startBroadcast(PRIVATE_KEY);

        (bytes32 messageId) = messageSender.send(
            FUJI_CHAIN_SELECTOR,
            MESSAGE_BROKER_ADDRESS,
            messageText
        );

        console.log(
            "You can now monitor the status of your Chainlink CCIP Message via https://ccip.chain.link using CCIP Message ID: "
        );
        console.logBytes32(messageId);

        vm.stopBroadcast();
    }
}