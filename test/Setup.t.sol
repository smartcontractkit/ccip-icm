// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {CCIPLocalSimulatorFork} from "@chainlink/local/src/ccip/CCIPLocalSimulatorFork.sol";
import {ITeleporterMessenger} from "src/icm/ITeleporterMessenger.sol";

import {MessageBroker} from "../src/MessageBroker.sol";
import {MessageSender} from "../src/MessageSender.sol";
import {MessageReceiver} from "../src/MessageReceiver.sol";

contract Setup is Test {
    bool private _baseTestInitialized;

    CCIPLocalSimulatorFork public ccipLocalSimulatorFork;
    uint256 public sepoliaFork;
    uint256 public fujiFork;
    uint256 public dispatchFork;

    MessageSender public messageSender;
    MessageBroker public messageBroker;
    MessageReceiver public messageReceiver;
    ITeleporterMessenger public teleporterMessenger;

    // local addresses //
    address public MESSAGE_SENDER_ADDRESS;
    address public MESSAGE_BROKER_ADDRESS;
    address public MESSAGE_RECEIVER_ADDRESS;

    address public constant WARP_PRECOMPILE_ADDRESS = 0x0200000000000000000000000000000000000005;

    uint256 public constant FAUCET_REQUEST_AMOUNT = 10 ether;
    string public messageText = "Hai Dispatch";

    string public FUJI_RPC_URL = vm.envString("FUJI_RPC_URL");
    string public SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
    string public DISPATCH_RPC_URL = vm.envString("DISPATCH_RPC_URL");

    // ETHEREUM SEPOLIA
    uint256 public SEPOLIA_CHAIN_ID = vm.envUint("SEPOLIA_CHAIN_ID");
    uint64 public SEPOLIA_CHAIN_SELECTOR = uint64(vm.envUint("SEPOLIA_CHAIN_SELECTOR"));
    address public SEPOLIA_ROUTER_ADDRESS = vm.envAddress("SEPOLIA_ROUTER_ADDRESS");
    
    // AVALANCHE FUJI
    uint256 public FUJI_CHAIN_ID = vm.envUint("FUJI_CHAIN_ID");
    bytes32 public FUJI_BLOCKCHAIN_ID = vm.envBytes32("FUJI_BLOCKCHAIN_ID");
    uint64 public FUJI_CHAIN_SELECTOR = uint64(vm.envUint("FUJI_CHAIN_SELECTOR"));
    address public FUJI_ROUTER_ADDRESS = vm.envAddress("FUJI_ROUTER_ADDRESS");
    address public TELEPORTER_MESSENGER_ADDRESS = vm.envAddress("TELEPORTER_MESSENGER_ADDRESS");
    // DISPATCH TESTNET
    bytes32 public DISPATCH_BLOCKCHAIN_ID = vm.envBytes32("DISPATCH_BLOCKCHAIN_ID");

    mapping (uint => string) public network;

    function setUp() public virtual {
        // creates: CCIP Local Simulator Fork.
        ccipLocalSimulatorFork = new CCIPLocalSimulatorFork();
        vm.makePersistent(address(ccipLocalSimulatorFork));

        setup_sepoliaFork();
        setup_fujiFork();
        setup_dispatchFork();

        // BaseTest.setUp is often called multiple times from tests' setUp due to inheritance.
        if (_baseTestInitialized) return;
        _baseTestInitialized = true;
    }

    // [SEPOLIA] CONFIGURATION //
    function setup_sepoliaFork() public {
        sepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL);
        messageSender = new MessageSender(SEPOLIA_ROUTER_ADDRESS);
        MESSAGE_SENDER_ADDRESS = address(messageSender);
        network[block.chainid] = 'Sepolia'; // 11155111
        deal(MESSAGE_SENDER_ADDRESS, 10 ether);
    }

    // [FUJI] CONFIGURATION //
    function setup_fujiFork() public {
        fujiFork = vm.createSelectFork(FUJI_RPC_URL);
        messageBroker = new MessageBroker(FUJI_ROUTER_ADDRESS);
        MESSAGE_BROKER_ADDRESS = address(messageBroker);
        network[block.chainid] = 'Fuji'; // 779672
    }

    // [DISPATCH] CONFIGURATION //
    function setup_dispatchFork() public {
        dispatchFork = vm.createSelectFork(DISPATCH_RPC_URL);
        teleporterMessenger = ITeleporterMessenger(TELEPORTER_MESSENGER_ADDRESS);
        messageReceiver = new MessageReceiver(TELEPORTER_MESSENGER_ADDRESS);
        MESSAGE_RECEIVER_ADDRESS = address(messageReceiver);
        network[block.chainid] = 'Dispatch'; // 43114
    }
}
