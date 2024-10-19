---
runme:
  id: 01JAHP47RB5NY6ZK8S63NGM47M
  version: v3
---

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

```sh {"id":"01JAHP47RB5NY6ZK8S5MGZA45M","vsls_cell_id":"9090b8ff-772e-4dec-a2e8-2074842a76f9"}
$ forge build
```

### Test

```sh {"id":"01JAHP47RB5NY6ZK8S5NTQ658A","vsls_cell_id":"749589ed-af3e-44dd-bea2-bdc404ab60df"}
$ forge test
```

### Format

```sh {"id":"01JAHP47RB5NY6ZK8S5SDPTBA9","vsls_cell_id":"5bed4ddb-47dc-47f0-ac9b-cf701320dc4a"}
$ forge fmt
```

### Gas Snapshots

```sh {"id":"01JAHP47RB5NY6ZK8S5T2EPA9E","vsls_cell_id":"3e291153-7a5e-4dd4-ad71-37b32f258a90"}
$ forge snapshot
```

### Anvil

```sh {"id":"01JAHP47RB5NY6ZK8S5VYXD43V","vsls_cell_id":"00fa354c-4e74-47be-86ec-134dac591e72"}
$ anvil
```

### Deploy

```sh {"id":"01JAHP47RB5NY6ZK8S5WS4V763","vsls_cell_id":"7f7f3d56-bc03-4831-97ba-072cb54e77e0"}
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```sh {"id":"01JAHP47RB5NY6ZK8S5XXX4JJ4","vsls_cell_id":"c2285952-1722-47e8-842b-e2ec900ac54d"}
$ cast <subcommand>
```

### Help

```sh {"id":"01JAHP47RB5NY6ZK8S5YBZ7KFQ","vsls_cell_id":"3f0eea6c-def2-4e0f-b9e5-8920d4ce91eb"}
$ forge --help
$ anvil --help
$ cast --help
```