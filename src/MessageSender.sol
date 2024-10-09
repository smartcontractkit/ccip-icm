// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {Withdraw} from "./utils/Withdraw.sol";

contract MessageSender is Withdraw {
    address public immutable routerAddress;
    string public latestText;
    bytes32 public latestMessageId;

    event MessageSent(bytes32 messageId);

    constructor(address _routerAddress) {
        routerAddress = _routerAddress;
    }

    receive() external payable {}

    function send(
        uint64 destinationChainSelector, 
        address brokerAddress, 
        string memory messageText
    ) external returns (bytes32 _latestMessageId) {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(brokerAddress),
            data: abi.encode(messageText),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 200_000})
            ),
            feeToken: address(0)
        });

        uint fee = IRouterClient(routerAddress).getFee(destinationChainSelector, message);

        latestText = messageText;
        latestMessageId = IRouterClient(routerAddress).ccipSend{value: fee}(destinationChainSelector, message);
    
        emit MessageSent(latestMessageId);
    
        return latestMessageId;
    }
}
