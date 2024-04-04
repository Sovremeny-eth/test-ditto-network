// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { MSAAdvancedTest } from "../erc7579/advanced/MSAAdvanced.t.sol";

contract MSAWithDittoNetworkTest is MSAAdvancedTest {
    function setUp() public virtual {
        //        executor.executeDelegateCall()
    }

    function test_msa_delegate_call_from_executor() public { }
}
