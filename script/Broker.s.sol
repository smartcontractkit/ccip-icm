// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BaseScript, console} from "./BaseScript.s.sol";
import {MessageBroker} from "../src/MessageBroker.sol";

contract BrokerMessage is BaseScript {
    MessageBroker messageBroker = MessageBroker(MESSAGE_BROKER_ADDRESS);

    function run() external {
        vm.startBroadcast(PRIVATE_KEY);

        bytes32 latestMessageId = messageBroker.latestMessageId();
        uint64 latestSourceChainSelector = messageBroker.latestSourceChainSelector();
        address latestSender = messageBroker.latestSender();
        string memory latestMessage = messageBroker.latestMessageText();

        console.log("=== Latest Message Details ===");
        console.log("\u2705 | MessageID: ");
        console.logBytes32(latestMessageId);
        console.log("\u2705 | Source Chain Selector:", latestSourceChainSelector);
        console.log("\u2705 | Sender:", latestSender);
        console.log("\u2705 | Message: \'%s\'", latestMessage);

        // console.log("\u231B | Brokering \'%s\' to Dispatch...", latestMessage);

        // bytes32 brokerMessageId =
        //     messageBroker.brokerMessage(
        //         MESSAGE_RECEIVER_ADDRESS // _destinationAddress
        // );

        // console.log("brokerMessageId: ");
        // console.logBytes32(brokerMessageId);
        // string memory messageBrokered = messageBroker.latestMessageText();
        // bytes32 latestBrokerMessageId = messageBroker.latestBrokeredId();
        // console.log("latestBrokerMessageId: ");
        // console.logBytes32(latestBrokerMessageId);

        // console.log("\u2705 | Brokered \'%s\'", messageBrokered);

        vm.stopBroadcast();
    }
}
