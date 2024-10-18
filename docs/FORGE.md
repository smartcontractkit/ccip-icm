# Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```sh {"vsls_cell_id":"9090b8ff-772e-4dec-a2e8-2074842a76f9"}
$ forge build
```

### Test

```sh {"vsls_cell_id":"749589ed-af3e-44dd-bea2-bdc404ab60df"}
$ forge test
```

### Format

```sh {"vsls_cell_id":"5bed4ddb-47dc-47f0-ac9b-cf701320dc4a"}
$ forge fmt
```

### Gas Snapshots

```sh {"vsls_cell_id":"3e291153-7a5e-4dd4-ad71-37b32f258a90"}
$ forge snapshot
```

### Anvil

```sh {"vsls_cell_id":"00fa354c-4e74-47be-86ec-134dac591e72"}
$ anvil
```

### Deploy

```sh {"vsls_cell_id":"7f7f3d56-bc03-4831-97ba-072cb54e77e0"}
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```sh {"vsls_cell_id":"c2285952-1722-47e8-842b-e2ec900ac54d"}
$ cast <subcommand>
```

### Help

```sh {"vsls_cell_id":"3f0eea6c-def2-4e0f-b9e5-8920d4ce91eb"}
$ forge --help
$ anvil --help
$ cast --help
```

---

## Verification Instructions

### Sepolia Example

```sh {"vsls_cell_id":"b1f560af-01d4-43ab-98b2-806c5a776df5"}
forge verify-contract $MESSAGE_SENDER_ADDRESS src/MessageSender.sol:MessageSender \
--rpc-url 'https://eth-sepolia.public.blastapi.io' \
--verifier blockscout \
--verifier-url 'https://eth-sepolia.blockscout.com/api/' \
```

### Fuji Example

```sh {"vsls_cell_id":"df94dbac-1d2b-4412-985f-4f836fa8a861"}
forge verify-contract $MESSAGE_BROKER_ADDRESS src/MessageBroker.sol:MessageBroker \
--rpc-url 'https://api.avax-test.network/ext/bc/C/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/43113/etherscan' \
--etherscan-api-key "verifyContract"
```

### Dispatch Example

```sh {"vsls_cell_id":"a78fdace-4b21-4b9d-9cad-a89df687956d"}
forge verify-contract $MESSAGE_RECEIVER_ADDRESS src/MessageReceiver.sol:MessageReceiver \
--rpc-url 'https://subnets.avax.network/dispatch/testnet/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/779672/etherscan' \
--verifier etherscan \
--etherscan-api-key "verifyContract"
```