// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {BaseScript, console} from "./BaseScript.s.sol";
import {MessageBroker} from "../src/MessageBroker.sol";
import {MessageSender} from "../src/MessageSender.sol";
import {MessageReceiver} from "../src/MessageReceiver.sol";

// https://eth-sepolia.blockscout.com/address/0x1272d0C7CBDD78d4dc2F35F6bB5B9c40fe944dA7?tab=contract
contract DeploySender is BaseScript {

    function run() external {
        vm.startBroadcast(PRIVATE_KEY);

        // deploys: MessageSender
        MessageSender messageSender = new MessageSender(SEPOLIA_ROUTER_ADDRESS);
        MESSAGE_SENDER_ADDRESS = payable(address(messageSender));

        console.log(
            "MessageSender[%s]: %s",
            block.chainid,
            MESSAGE_SENDER_ADDRESS
        );

        vm.stopBroadcast();
    }
}

// https://testnet.snowtrace.io/address/0x0a10A4AfE5E852bdaE91678f98fE71168B048e41/contract/779672/code
contract DeployBroker is BaseScript {

    function run() external {
        vm.startBroadcast(PRIVATE_KEY);

        // deploys: MessageBroker
        MessageBroker messageBroker = new MessageBroker(FUJI_ROUTER_ADDRESS);
        MESSAGE_BROKER_ADDRESS = payable(address(messageBroker));

        console.log(
            "MessageBroker[%s]: %s",
            block.chainid,
            MESSAGE_BROKER_ADDRESS
        );

        vm.stopBroadcast();
    }
}
// https://779672.testnet.snowtrace.io/address/0x0d0debEFCaC433885a51B32c359Cc971522F29cD/contract/779672/code
contract DeployReceiver is BaseScript {

    function run() external {
        vm.startBroadcast(PRIVATE_KEY);

        // deploys: MessageReceiver
        MessageReceiver messageReceiver = new MessageReceiver(TELEPORTER_MESSENGER_ADDRESS);
        MESSAGE_RECEIVER_ADDRESS = payable(address(messageReceiver));

        console.log(
            "MessageReceiver[%s]: %s",
            block.chainid,
            MESSAGE_RECEIVER_ADDRESS
        );

        vm.stopBroadcast();
    }
}