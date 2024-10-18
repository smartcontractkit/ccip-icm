// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {console, Enchanted} from "./Enchanted.sol";

contract SenderTest is Enchanted {

    function test_sendMessage() public {
        (uint _sentFrom, bytes32 _sentMessageId, string memory _textSent) = _send(messageText);
        
        assertEq(_sentMessageId, messageSender.latestMessageId());
        assertEq(_textSent, messageText);
        console.log('\u2705 | Sent on %s', network[_sentFrom]);
    }
}
