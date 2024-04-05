forge build
FOUNDRY_PROFILE=optimized forge test --gas-report --match-path test/polygon/KernelWithDittoNetwork.t.sol > gas/kernel-report.txt
FOUNDRY_PROFILE=optimized forge test --gas-report --match-path test/polygon/MSAWithDittoNetwork.t.sol > gas/msa-report.txt
