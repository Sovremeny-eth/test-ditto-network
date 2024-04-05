# Test ditto network

## Prerequisites

- [pnpm] package manager
- [foundry] ethereum testing framework

[pnpm]: https://pnpm.io/
[foundry]: https://github.com/foundry-rs/foundry

## Dependencies

```
pnpm install && forge install
```

## Build

```
forge build
forge test
```

More commands:

- `pnpm run install:submodules` - install submodules for new repository
- `pnpm run gas:report` - gas report with tests for deploy
- `pnpm run clean` - deletes all build folders

## Project structure

1. `script` - the logic of deployment, test environment creation and the registry of contracts
2. `src` - code of contracts
3. `test` - tests for contracts

## Resources

- [Learn more about plugins](https://docs.zerodev.app/sdk/plugins/intro)
- [Read the source code](https://github.com/zerodevapp/kernel)
- [ERC7579](https://github.com/erc7579/erc7579-implementation)
- [Ditto Network Smart Contracts](https://github.com/dittonetwork/blast-contracts)