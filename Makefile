-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil scopefile deploy-bridges

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Commands executed in make.
all: install build # remove

# Clean Repo
clean  :; forge clean

# Remove Modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

# Install Libs
install :; forge install https://github.com/foundry-rs/forge-std lib/forge-std --no-commit && forge install https://github.com/OpenZeppelin/openzeppelin-contracts lib/openzeppelin-contracts --no-commit && forge install https://github.com/smartcontractkit/ccip lib/ccip --no-commit && forge install https://github.com/ava-labs/teleporter lib/teleporter --no-commit && forge install https://github.com/ava-labs/avalanche-interchain-token-transfer lib/avalanche-interchain-token-transfer --no-commit && forge install https://github.com/ava-labs/subnet-evm lib/subnet-evm --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test