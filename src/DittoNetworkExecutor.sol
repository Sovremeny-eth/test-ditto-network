// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

//import { POLYGON_UNIVERSAL_VAULT_ADDRESS } from "./DittoConstants.sol";
//import { IUniversalVault } from "../script/polygon/IUniversalVault.sol";
import { IExecutor, MODULE_TYPE_EXECUTOR } from "./erc7579/interfaces/IERC7579Module.sol";
import { IERC7579Account } from "./erc7579/interfaces/IERC7579Account.sol";
import { ExecutionLib } from "src/erc7579/lib/ExecutionLib.sol";
import {
    ModeLib,
    CALLTYPE_DELEGATECALL,
    EXECTYPE_DEFAULT,
    MODE_DEFAULT,
    ModePayload
} from "./erc7579/lib/ModeLib.sol";
import { IExecutionLogic } from "src/ditto/vault/logics/ExecutionLogic.sol";

contract DittoNetworkExecutor is IExecutor {
    function onInstall(bytes calldata data) external override { }

    function onUninstall(bytes calldata data) external override { }

    function executeDittoFunctions(
        IERC7579Account account,
        address target,
        uint256 value,
        bytes calldata callData
    ) external returns (bytes[] memory returnData) {
        return account.executeFromExecutor(
            ModeLib.encodeSimpleSingle(), ExecutionLib.encodeSingle(target, value, callData)
        );
    }

    function kernelExecuteDittoFunctions(address target, bytes[] calldata data) external payable {
        IExecutionLogic(target).multicall(data);
    }

    function isModuleType(uint256 moduleTypeId) external view override returns (bool) {
        return moduleTypeId == MODULE_TYPE_EXECUTOR;
    }

    function isInitialized(address smartAccount) public view override returns (bool) {
        return false;
    }
}
