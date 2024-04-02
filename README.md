# Test ditto network

## Prerequisites

- [pnpm] package manager
- [forge] ethereum testing framework

[pnpm]: https://pnpm.io/
[forge]: https://github.com/foundry-rs/foundry

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

- `pnpm run dev` - TODO

## Project structure

1. `script` - the logic of deployment, test environment creation and the registry of contracts
2. `src` - code of contracts
3. `test` - tests for contracts

## Resources

- [Learn more about plugins](https://docs.zerodev.app/sdk/plugins/intro)
- [Read the source code](https://github.com/zerodevapp/kernel)
- [Ditto Network Smart Contracts](https://github.com/dittonetwork/blast-contracts)