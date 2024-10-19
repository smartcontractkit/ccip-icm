---
runme:
  id: 01JAHNYDRKXDD9PSPBQ3BKWFAX
  version: v3
---

> _This repository represents an example of using a Chainlink product or service. It is provided to help you understand how to interact with Chainlink’s systems so that you can integrate them into your own. This template is provided "AS IS" without warranties of any kind, has not been audited, and may be missing key checks or error handling to make the usage of the product more clear. Take everything in this repository as an example and not something to be copy pasted into a production ready service._

# ccip-avalanche

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/bunsdev/ccip-icm/tree/gitpod)

Demonstrating how to use Chainlink Cross-Chain Interoperobility Protocol (CCIP) and Avalanche Interchain Messaging (ICM) to send a message from Ethereum Sepolia to Avalanche Fuji (_via CCIP_), then forwarding that message from Avalanche Fuji to Dispatch L1 (_via ICM_).

# Getting Started

In the next section you can see how to send data from one chain to another. But before that, you need to set up some environment variables, install dependencies, setup environment variables, and compile contracts.

## **1. Install Dependencies**

```bash {"id":"01JAHF52E6YWX9D7J5M3HE6WD5","vsls_cell_id":"cd2b2274-6032-4d78-b663-f24e2ec684f1"}
yarn && make
```

## **2. Setup Environment**

Run the command below, then update the .env `PRIVATE_KEY` and `ETHERSCAN_API_KEY` variables.

```bash {"id":"01JAHF52E6YWX9D7J5M6Z4E33Z","name":"","promptEnv":"auto","vsls_cell_id":"294c87a7-e413-4580-9d15-e062a1d33301"}
if [ -f .env ]; then
    echo "We will use the .env your have already created."
    else
    if [ -z "${DOTENV}" ]; then
        echo "Creating and setting .env"
        cp .env.example .env && source .env
        echo "Set your PRIVATE_KEY and ETHERSCAN_API_KEY in .env"
    fi
fi
```

## **3. Create Wallet**

To create a new wallet that is stored in a keystore, issue the following command, which will prompt you to secure the private key with a password.

```bash {"id":"01JAHF52E6YWX9D7J5M8C0AYQB","vsls_cell_id":"9e50f506-0471-40a9-8402-01334d462096"}
# Grabs the PRIVATE_KEY from the .env file.
PRIVATE_KEY=$(grep PRIVATE_KEY .env | cut -d '=' -f2)

if [ -f keystore/secret ]; then
    echo "Found keystore in workspace"
    else
    if [ -z "${DOTENV}" ]; then
        echo "Creating and setting keystore"
        mkdir keystore
        cast wallet import --private-key $PRIVATE_KEY -k keystore secret
        echo "keystore/secret created"
    fi
fi

```

For ease use of the keystore we already configured a environment variable called `KEYSTORE` pointing to the `keystore` file in the working directory.

You can use the wallet stored in the keystore by adding the `--keystore` flag instead of the `--private-key` flag. Run the command below to confirm your wallet address is stored accurately.

```bash {"id":"01JAHF52E6YWX9D7J5M98Q97Y9","vsls_cell_id":"322c9173-27be-4d3e-b47c-9549367b4047"}
KEYSTORE=$(grep KEYSTORE .env | cut -d '=' -f2)

cast wallet address --keystore $KEYSTORE
```

## **4. Prepare Smart Contracts**

### **Smart Contract Design**

![messaging-process](./img/messaging-process.png)

Before we proceed with deployment, it is best practice to run tests, which can be executed as follows:

```bash {"id":"01JAHNS604RBGEEFCHXR8WWVN8"}
forge test --match-contract SenderTest -vv
```

```bash {"id":"01JAHNV8AM7Q0B9Z03HPTX7Z7M"}
forge test --match-contract BrokerTest -vv
```

```bash {"id":"01JAHNV7H74JHNGPZZCPNJNXPM"}
forge test --match-contract ReceiverTest -vv
```

**In order to interact with our contracts, we first need to deploy them, which is simplified in the [`script/Deploy.s.sol`](./script/Deploy.s.sol) smart contract, so let's deploy each contract applying the deployment script for each of the following commands.**

#### [`MessageSender.sol`](./src/MessageSender.sol) via [`Deploy.s.sol`](./script/Deploy.s.sol#L10)

```sh {"id":"01JAHF52E6YWX9D7J5MAWXKZ61","vsls_cell_id":"43b7fbea-91eb-4d70-a863-dc11f0264416"}
forge script ./script/Deploy.s.sol:DeploySender -vvv --broadcast --rpc-url ethereumSepolia
```

Update `MESSAGE_SENDER_ADDRESS` stored in your .env, then make sure to verify the deployment by running the following command:

```sh {"id":"01JAHP9NFBQSQJQTYKX1VJFK63"}
export MESSAGE_SENDER_ADDRESS=$(grep MESSAGE_SENDER_ADDRESS .env | cut -d '=' -f2)

forge verify-contract $MESSAGE_SENDER_ADDRESS src/MessageSender.sol:MessageSender \
--rpc-url 'https://eth-sepolia.public.blastapi.io' \
--verifier blockscout \
--verifier-url 'https://eth-sepolia.blockscout.com/api/'

echo "Verified MessageSender contract may be found here: https://eth-sepolia.blockscout.com/address/$MESSAGE_SENDER_ADDRESS?tab=contract"
```

**Finally, since the MessageSender requires funds to pay for fees, we will load up the contract programatically, as follows with 0.05 ETH:**

```sh {"id":"01JAHQBPBF19KE69P10706JA6S"}
KEYSTORE=$(grep KEYSTORE .env | cut -d '=' -f2)

cast send $MESSAGE_SENDER_ADDRESS --rpc-url ethereumSepolia --value 0.05ether --keystore $KEYSTORE
```

#### [`MessageBroker.sol`](./src/MessageBroker.sol) via [`Deploy.s.sol`](./script/Deploy.s.sol#L30)

```sh {"id":"01JAHF52E6YWX9D7J5MDKDTH3S","vsls_cell_id":"7ff89f1f-12d9-47bb-bc18-a37c8c55dac8"}
forge script ./script/Deploy.s.sol:DeployBroker -vvv --broadcast --rpc-url avalancheFuji
```

Update `MESSAGE_BROKER_ADDRESS` stored in your .env, then make sure to verify the deployment by running the following command:

```sh {"id":"01JAHQ2HBNF5K19C4D38WDYRTT"}
export MESSAGE_BROKER_ADDRESS=$(grep MESSAGE_BROKER_ADDRESS .env | cut -d '=' -f2)

forge verify-contract $MESSAGE_BROKER_ADDRESS src/MessageBroker.sol:MessageBroker \
--rpc-url 'https://api.avax-test.network/ext/bc/C/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/43113/etherscan' \
--etherscan-api-key "verifyContract"

echo "Verified MessageBroker contract may be found here: https://testnet.snowtrace.io/address/$MESSAGE_BROKER_ADDRESS/contract/43113/code"
```

#### [`MessageReceiver.sol`](./src/MessageReceiver.sol) via [`Deploy.s.sol`](./script/Deploy.s.sol#L49)

```sh {"id":"01JAHF52E6YWX9D7J5MFP17XRN","vsls_cell_id":"83eabce3-edae-498c-8644-906ce400e2dc"}
forge script ./script/Deploy.s.sol:DeployReceiver -vvv --broadcast --rpc-url dispatchTestnet
```

Update `MESSAGE_RECEIVER_ADDRESS` stored in your .env, then make sure to verify the deployment by running the following command:

```sh {"id":"01JAHQ9NH55T0SNM6BX025KK34"}
export MESSAGE_RECEIVER_ADDRESS=$(grep MESSAGE_RECEIVER_ADDRESS .env | cut -d '=' -f2)

forge verify-contract $MESSAGE_RECEIVER_ADDRESS src/MessageReceiver.sol:MessageReceiver --etherscan-api-key 'verifyContract' \
&& orge verify-contract $MESSAGE_RECEIVER_ADDRESS src/MessageReceiver.sol:MessageReceiver \
--rpc-url 'https://subnets.avax.network/dispatch/testnet/rpc' \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/779672/etherscan' \

echo "Verified MessageReceiver contract may be found here: https://779672.testnet.snowtrace.io/address/$MESSAGE_RECEIVER_ADDRESS/contract/779672/code"
```

---

# Messaging Cross-Chain

> *Before proceeding, please ensure you have completed the steps outlined in the [Setup Messaging Scenario](#setup-messaging-scenario) section above.*

## **1. Ethereum Sepolia &rarr; Avalanche Fuji**

### Sending Message (Sepolia &rarr; Fuji)

Run the following to send a message to Fuji from Sepolia via the `SendMessage` functionality coded in [Send.s.sol](./script/Send.s.sol):

```bash {"id":"01JAHF52E6YWX9D7J5MJ6Z6CAV","promptEnv":"yes","vsls_cell_id":"001a3bf3-2a75-4bd5-bd9a-46e602e080c3"}
export CUSTOM_MESSAGE=""
if [ -z "${CUSTOM_MESSAGE}" ]; then
    echo "No custom message provided"
    else
    echo "Sending \`$CUSTOM_MESSAGE\` to Avalanche"
fi

forge script ./script/Send.s.sol:SendMessage -vvv --broadcast --rpc-url ethereumSepolia --sig "run(string)" -- "$CUSTOM_MESSAGE"

# https://ccip.chain.link/#/side-drawer/msg/0x30917345c2214ca9a26631f24f30e67b0f7d3aef2285c4ec108a124d944886f1
```

## **2. Avalanche Fuji &rarr; Dispatch Testnet**

### Brokering Message (Fuji &rarr; Dispatch)

Once the message is finalized on the broker chain (*Fuji*), you may see the details about the latest message via the `BrokerMessage` functionality coded in [Broker.s.sol](./script/Broker.s.sol). After you have confirmed the latest message you received looks good, you may proceed with running the following script to broker the message to Dispatch:

```bash {"id":"01JAHF52E6YWX9D7J5MNNZS0H6","vsls_cell_id":"68e3c9cb-d636-495f-a817-a07ebbbadb93"}
MESSAGE_BROKER_ADDRESS=$(grep MESSAGE_BROKER_ADDRESS .env | cut -d '=' -f2)
MESSAGE_RECEIVER_ADDRESS=$(grep MESSAGE_RECEIVER_ADDRESS .env | cut -d '=' -f2)
KEYSTORE=$(grep KEYSTORE .env | cut -d '=' -f2)

cast send $MESSAGE_BROKER_ADDRESS --rpc-url avalancheFuji --keystore $KEYSTORE "brokerMessage(address)" $MESSAGE_RECEIVER_ADDRESS
```

## **3. Dispatch Testnet**

### Receiving Message (Dispatch)

After running the script above to broker the message from Fuji to Dispatch, you may confirm the message was received by running the following script:

```bash {"id":"01JAHF52E792FQD6XFKMTZMFR0","vsls_cell_id":"dc6d52d2-1468-48a0-8634-526abe534f0c"}
forge script ./script/Receive.s.sol:ReceiveMessage -vvv --broadcast --rpc-url dispatchTestnet
```