// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { DittoNetworkExecutor } from "src/DittoNetworkExecutor.sol";
import { KernelECDSATest } from "../kernel/KernelECDSA.t.sol";

contract KernelWithDittoNetworkTest is KernelECDSATest {
    DittoNetworkExecutor executor;

    function setUp() public virtual {
        executor = new DittoNetworkExecutor();
    }

    function test_kernel_delegate_call_from_executor() public { }
}
