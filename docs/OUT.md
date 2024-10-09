>> yarn sendMessage "Hai Dispatch"
>> You can now monitor the status of your Chainlink CCIP Message via https://ccip.chain.link using CCIP Message ID: 0x72c8d3213e1cf593670bef00caa748815848ea7efc9fbd9bfe29e1eeedde5943

https://ccip.chain.link/msg/0x72c8d3213e1cf593670bef00caa748815848ea7efc9fbd9bfe29e1eeedde5943

---

>> yarn brokerMessage
>> cast send 0x0a10A4AfE5E852bdaE91678f98fE71168B048e41 --rpc-url avalancheFuji --keystore keystore "
brokerMessage(bytes32,address,uint256,string)" 0x0d0debEFCaC433885a51B32c359Cc971522F29cD

>> 

---
<!-- >> yarn receiveMessage "Hai Dispatch" -->

>> cast call 0x0d0debEFCaC433885a51B32c359Cc971522F29cD --keystore keystore --rpc-url dispatchTestnet
 "lastMessageReceived()"