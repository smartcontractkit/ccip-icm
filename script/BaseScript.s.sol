// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {console, Script} from "forge-std/Script.sol";

contract BaseScript is Script {
    address public SEPOLIA_ROUTER_ADDRESS = vm.envAddress("SEPOLIA_ROUTER_ADDRESS");
    address public FUJI_ROUTER_ADDRESS = vm.envAddress("FUJI_ROUTER_ADDRESS");
    address public TELEPORTER_MESSENGER_ADDRESS = vm.envAddress("TELEPORTER_MESSENGER_ADDRESS");
    bytes32 public DISPATCH_BLOCKCHAIN_ID = bytes32(hex"9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7");

    uint64 public FUJI_CHAIN_SELECTOR = uint64(vm.envUint("FUJI_CHAIN_SELECTOR"));
    address constant WARP_PRECOMPILE_ADDRESS = 0x0200000000000000000000000000000000000005;
    uint256 public constant DEFAULT_REQUIRED_GAS_LIMIT = 1e6;

    uint PRIVATE_KEY = vm.envUint("PRIVATE_KEY");

    // update upon deployment //
    address payable MESSAGE_SENDER_ADDRESS = payable(vm.envAddress("MESSAGE_SENDER_ADDRESS"));
    address payable MESSAGE_BROKER_ADDRESS = payable(vm.envAddress("MESSAGE_BROKER_ADDRESS"));
    address payable MESSAGE_RECEIVER_ADDRESS = payable(vm.envAddress("MESSAGE_RECEIVER_ADDRESS"));
}