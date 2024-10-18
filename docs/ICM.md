# Instructions - Send & Receive

The following code example will show you how to send, receive and verify the receival of messages using teleporter and foundry.

## Fuji Testnet

### Funding your Wallet with Fuji Tokens

Head to the [Avalanche Testnet Faucet](https://core.app/tools/testnet-faucet/?subnet=c&token=c) and fund your keystore address with Fuji AVAX and Dispatch tokens. Use the coupon code `avalanche-academy`.

### Setting the Blockchain ID in the Contracts on Fuji

Make sure to adapt the destinationBlockchainID of your sending contracts to use the blockchain IDs of the Fuji network:

| Chain | Blockchain ID |
|-------|---------------|
| Fuji C-Chain | 0x7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5 |
| Dispatch | 0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7 |

---

# Resources

- [Chain Configurations](https://github.com/ava-labs/public-avalanche-sdks/blob/main/apps/teleporter-demo/src/constants/chains.ts)
- [TeleporterTests](https://github.com/ava-labs/teleporter/blob/main/contracts/teleporter/tests/TeleporterMessengerTest.t.sol)
- [Example Teleporter Token](https://subnets-test.avax.network/c-chain/address/0x6F419E35a60439569640ca078ba5e86599E30cC6)
- **Subnets Explorers**

   - [Dispatch](https://subnets-test.avax.network/dispatch)
   - [Echo](https://subnets-test.avax.network/echo)

- **Teleporter**

   - [Bridge UI](https://ohmywarp.com)

---

# Avalanche CLI

## Install Avalanche CLI (Linux and Mac, PC is not yet supported)

```sh {"vsls_cell_id":"5393c200-7877-41dc-965b-9a525a303c4f"}
curl -sSfL https://raw.githubusercontent.com/ava-labs/avalanche-cli/main/scripts/install.sh | sh -s
```

### Adding Avalanche-CLI to your PATH

- To call the avalanche binary from anywhere, you'll need to add it to your system path. If you installed the binary into the default location, you can run the following snippet to add it to your path.
- To add it to your path permanently, add an export command to your shell initialization script. If you run bash, use .bashrc. If you run zsh, use .zshrc.

For example:
`export PATH=~/bin:$PATH >> .zshrc`

---

## ITeleporterMessenger Interface

**ITeleporterMessenger interface provides two primary methods**:

- `sendCrossChainMessage`: called by contracts on the origin chain to initiate the sending of a message to a contract on another EVM instance.
- `receiveCrossChainMessage`: called by cross-chain relayers on the destination chain to deliver signed messages to the destination EVM instance.
   The ITeleporterReceiver interface provides a single method. All contracts that wish to receive Teleporter messages on the destination chain must implement this interface:
- `receiveTeleporterMessage`: called by the Teleporter contract on the destination chain to deliver a message to the destination contract.

---

# Resources

- **Data Flow**: https://docs.avax.network/cross-chain/teleporter/overview#data-flow
- **Deep Dive**: https://docs.avax.network/cross-chain/teleporter/deep-dive
- [Avalanche-Starter-Kit Repo](https://github.com/ava-labs/avalanche-starter-kit)