// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// vault
import { IVault } from "src/ditto/vault/interfaces/IVault.sol";
import { IEventsAndErrors } from "src/ditto/vault/interfaces/IEventsAndErrors.sol";

import { IAccountAbstractionLogic } from "src/ditto/vault/interfaces/IAccountAbstractionLogic.sol";

// common methods
import { IVersionUpgradeLogic } from "src/ditto/vault/interfaces/IVersionUpgradeLogic.sol";
import { IAccessControlLogic } from "src/ditto/vault/interfaces/IAccessControlLogic.sol";
import { IEntryPointLogic } from "src/ditto/vault/interfaces/IEntryPointLogic.sol";
import { IExecutionLogic } from "src/ditto/vault/interfaces/IExecutionLogic.sol";
import { IVaultLogic } from "src/ditto/vault/interfaces/IVaultLogic.sol";
import { INativeWrapper } from "src/ditto/vault/interfaces/ourLogic/helpers/INativeWrapper.sol";

// dex methods
import { IDexBaseLogic } from "src/ditto/vault/interfaces/ourLogic/dexAutomation/IDexBaseLogic.sol";
import { IUniswapLogic } from "src/ditto/vault/interfaces/ourLogic/dexAutomation/IUniswapLogic.sol";

// aave methods
import { IAaveActionLogic } from "src/ditto/vault/interfaces/ourLogic/IAaveActionLogic.sol";
import { IDeltaNeutralStrategyLogic } from
    "src/ditto/vault/interfaces/ourLogic/IDeltaNeutralStrategyLogic.sol";

// checkers
import { IAaveCheckerLogic } from "src/ditto/vault/interfaces/checkers/IAaveCheckerLogic.sol";
import { IPriceCheckerLogicUniswap } from
    "src/ditto/vault/interfaces/checkers/IPriceCheckerLogicUniswap.sol";
import { IPriceDifferenceCheckerLogicUniswap } from
    "src/ditto/vault/interfaces/checkers/IPriceDifferenceCheckerLogicUniswap.sol";
import { ITimeCheckerLogic } from "src/ditto/vault/interfaces/checkers/ITimeCheckerLogic.sol";
import { IDexCheckerLogicUniswap } from
    "src/ditto/vault/interfaces/checkers/IDexCheckerLogicUniswap.sol";

// bridges
import { IStargateLogic } from "src/ditto/vault/interfaces/ourLogic/bridges/IStargateLogic.sol";
import { ILayerZeroLogic } from "src/ditto/vault/interfaces/ourLogic/bridges/ILayerZeroLogic.sol";
import { ICelerCircleBridgeLogic } from
    "src/ditto/vault/interfaces/ourLogic/bridges/ICelerCircleBridgeLogic.sol";

interface IUniversalVault is
    IVault,
    IEventsAndErrors,
    IVersionUpgradeLogic,
    IAccountAbstractionLogic,
    IAccessControlLogic,
    IEntryPointLogic,
    IExecutionLogic,
    IVaultLogic,
    INativeWrapper,
    IDexBaseLogic,
    IUniswapLogic,
    IAaveActionLogic,
    IDeltaNeutralStrategyLogic,
    IAaveCheckerLogic,
    IPriceCheckerLogicUniswap,
    IPriceDifferenceCheckerLogicUniswap,
    ITimeCheckerLogic,
    IStargateLogic,
    ILayerZeroLogic,
    ICelerCircleBridgeLogic,
    IDexCheckerLogicUniswap
{ }
