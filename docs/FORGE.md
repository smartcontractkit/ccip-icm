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

```sh
$ forge build
```

### Test

```sh
$ forge test
```

### Format

```sh
$ forge fmt
```

### Gas Snapshots

```sh
$ forge snapshot
```

### Anvil

```sh
$ anvil
```

### Deploy

```sh
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```sh
$ cast <subcommand>
```

### Help

```sh
$ forge --help
$ anvil --help
$ cast --help
```

---

## Verification Instructions

### Sepolia Example

```sh
forge verify-contract $MESSAGE_SENDER_ADDRESS src/MessageSender.sol:MessageSender \
--rpc-url 'https://eth-sepolia.public.blastapi.io' \
--verifier blockscout \
--verifier-url 'https://eth-sepolia.blockscout.com/api/' \
```

### Fuji Example

```sh
forge verify-contract $MESSAGE_BROKER_ADDRESS src/MessageBroker.sol:MessageBroker \
--rpc-url 'https://api.avax-test.network/ext/bc/C/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/43113/etherscan' \
--etherscan-api-key "verifyContract"
```

### Dispatch Example

```sh
forge verify-contract $MESSAGE_RECEIVER_ADDRESS src/MessageReceiver.sol:MessageReceiver \
--rpc-url 'https://subnets.avax.network/dispatch/testnet/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/779672/etherscan' \
--verifier etherscan \
--etherscan-api-key "verifyContract"
```