// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import { Test, console2 } from "forge-std/Test.sol";
import { POLYGON_ENTRYPOINT_0_6_0 } from "src/DittoConstants.sol";
import { DittoNetworkExecutor } from "src/DittoNetworkExecutor.sol";

import { IEntryPoint } from "I4337/interfaces/IEntryPoint.sol";
import { CREATOR_0_6_BYTECODE, CREATOR_0_6_ADDRESS } from "I4337/artifacts/EntryPoint_0_6.sol";
import "src/kernel/Kernel.sol";
import "src/kernel/validator/ECDSAValidator.sol";
import { ERC4337Utils } from "src/kernel/utils/ERC4337Utils.sol";
import { KernelTestBase } from "src/kernel/utils/KernelTestBase.sol";
import { DittoNetworkExecutor } from "src/DittoNetworkExecutor.sol";
import { TestValidator } from "src/kernel/mock/TestValidator.sol";
import { IKernel } from "src/kernel/interfaces/IKernel.sol";
import { KernelFactory } from "src/kernel/factory/KernelFactory.sol";
import { IKernelValidator } from "src/kernel/interfaces/IKernelValidator.sol";
import { ValidUntil, ValidAfter } from "src/kernel/common/Types.sol";

import { FullDeploy, Registry, VaultProxyAdmin } from "../../script/FullDeploy.s.sol";
import { IUniswapV3Pool } from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import { ProtocolFees } from "../../src/ditto/ProtocolFees.sol";
import { VaultFactory } from "../../src/ditto/VaultFactory.sol";
import { BaseContract } from "../../src/ditto/vault/libraries/BaseContract.sol";
import { ExecutionLogic, IExecutionLogic } from "../../src/ditto/vault/logics/ExecutionLogic.sol";
import { VaultLogic } from "../../src/ditto/vault/logics/VaultLogic.sol";
import { UniswapLogic } from "../../src/ditto/vault/logics/OurLogic/dexAutomation/UniswapLogic.sol";
import { TransferHelper } from "../../src/ditto/vault/libraries/utils/TransferHelper.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { VaultLogic } from "../../src/ditto/vault/logics/VaultLogic.sol";
import { IEntryPointLogic } from "../../src/ditto/vault/logics/EntryPointLogic.sol";
import { IExecutionLogic } from "../../src/ditto/vault/logics/ExecutionLogic.sol";

contract KernelWithDittoNetworkTest is Test, FullDeploy {
    Kernel kernel;
    Kernel kernelImpl;
    KernelFactory factory;
    IEntryPoint entryPoint;
    IKernelValidator defaultValidator;
    address owner;
    uint256 ownerKey;
    address payable beneficiary;
    address factoryOwner;

    bytes4 executionSig;
    ExecutionDetail executionDetail;
    DittoNetworkExecutor dittoExecutor;

    bool isTest = true;
    Registry.Contracts reg;
    IUniswapV3Pool pool = IUniswapV3Pool(0x45dDa9cb7c25131DF268515131f647d726f50608);
    uint24 poolFee;

    address usdcAddress = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address wethAddress = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    address wmaticAddress = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address donor = 0x55CAaBB0d2b704FD0eF8192A7E35D8837e678207; // wallet for token airdrop

    address vaultOwner = makeAddr("VAULT_OWNER");
    address vault; // implementation
    uint256 nftId;

    function setUp() public {
        vm.createSelectFork(vm.envString("POLYGON_RPC_URL"));
        vm.txGasPrice(80000000000);

        (owner, ownerKey) = makeAddrAndKey("owner");
        (factoryOwner,) = makeAddrAndKey("factoryOwner");
        beneficiary = payable(address(makeAddr("beneficiary")));

        entryPoint = IEntryPoint(payable(POLYGON_ENTRYPOINT_0_6_0));
        vm.etch(CREATOR_0_6_ADDRESS, CREATOR_0_6_BYTECODE);

        kernelImpl = new Kernel(entryPoint);
        factory = new KernelFactory(factoryOwner, entryPoint);

        vm.startPrank(factoryOwner);
        factory.setImplementation(address(kernelImpl), true);
        vm.stopPrank();

        defaultValidator = new ECDSAValidator();

        _setAddress();

        executionDetail.executor = address(new DittoNetworkExecutor());
        executionSig = DittoNetworkExecutor.kernelExecuteDittoFunctions.selector;
        executionDetail.validator = new TestValidator();

        _initializeDitto();
    }

    // =========================
    // Run
    // =========================

    event Upgraded(address indexed);

    function test_polygon_add_ditto_impl() external {
        UserOperation memory op = _fillUserOp(
            entryPoint,
            address(kernel),
            abi.encodeWithSelector(IKernel.upgradeTo.selector, address(vault))
        );
        vm.expectEmit();
        emit IKernel.Upgraded(address(vault));
        _performUserOperationWithSig(op);

        // UserOperation memory opForInit = _fillUserOp(
        //    entryPoint,
        //    address(kernel),
        //    abi.encodeWithSelector(
        //        IKernel.executeDelegateCall.selector,
        //        address(POLYGON_UNIVERSAL_VAULT_ADDRESS),
        //        abi.encodeWithSelector(
        //            IUniversalVault(POLYGON_UNIVERSAL_VAULT_ADDRESS).initializeCreatorAndId.selector,
        //            creator,
        //            vaultId
        //        )
        //    )
        //);
        // _performUserOperationWithSig(opForInit);
    }

    event EntryPointAddWorkflow(uint128);

    function test_polygon_add_workflow_multicall() external {
        (IEntryPointLogic.Checker[] memory checkers, IEntryPointLogic.Action[] memory actions) =
            _checkersAndActionsWithActionRef();

        bytes[] memory multicallData = new bytes[](1);

        multicallData[0] = abi.encodeCall(
            IEntryPointLogic(vault).addWorkflow, (checkers, actions, address(kernel), 0)
        );

        // TODO: it is not possible to make an delegate call because the storage is not initialized
        UserOperation memory op = _fillUserOp(
            entryPoint,
            address(kernel),
            abi.encodeWithSelector(
                IKernel.execute.selector,
                address(vault),
                0,
                abi.encodeWithSelector(IExecutionLogic.multicall.selector, multicallData),
                Operation.Call
            )
        );
        vm.expectEmit();
        emit IEntryPointLogic.EntryPointAddWorkflow(0);
        _performUserOperationWithSig(op);

        IEntryPointLogic.Workflow memory workflow = IEntryPointLogic(vault).getWorkflow(0);
        assertEq(workflow.actions[0].data, actions[0].data);
    }

    event ExecutionChanged(bytes4 indexed, address indexed, address indexed);

    function test_polygon_add_workflow_multicall_with_executor() external {
        UserOperation memory op = _fillUserOp(
            entryPoint,
            address(kernel),
            abi.encodeWithSelector(
                IKernel.setExecution.selector,
                executionSig,
                executionDetail.executor,
                executionDetail.validator,
                ValidUntil.wrap(0),
                ValidAfter.wrap(0),
                abi.encodePacked(owner)
            )
        );
        vm.expectEmit();
        emit ExecutionChanged(
            executionSig, executionDetail.executor, address(executionDetail.validator)
        );
        _performUserOperationWithSig(op);

        ExecutionDetail memory _executionDetail = kernel.getExecution(executionSig);
        assertEq(_executionDetail.executor, executionDetail.executor);

        (IEntryPointLogic.Checker[] memory checkers, IEntryPointLogic.Action[] memory actions) =
            _checkersAndActionsWithActionRef();

        bytes[] memory multicallData = new bytes[](1);

        multicallData[0] = abi.encodeCall(
            IEntryPointLogic(vault).addWorkflow, (checkers, actions, address(kernel), 0)
        );

        UserOperation memory workflowOp = _fillUserOp(
            entryPoint,
            address(kernel),
            abi.encodeWithSelector(executionSig, address(vault), multicallData)
        );
        vm.expectEmit();
        emit IEntryPointLogic.EntryPointAddWorkflow(0);
        _performUserOperationWithSig(workflowOp);

        IEntryPointLogic.Workflow memory workflow = IEntryPointLogic(vault).getWorkflow(0);
        assertEq(workflow.actions[0].data, actions[0].data);
    }

    // =========================
    // Helpers
    // =========================

    function _checkersAndActionsWithActionRef()
        internal
        view
        returns (IEntryPointLogic.Checker[] memory, IEntryPointLogic.Action[] memory)
    {
        IEntryPointLogic.Checker[] memory checkers = new IEntryPointLogic.Checker[](0);
        IEntryPointLogic.Action[] memory actions = new IEntryPointLogic.Action[](1);

        actions[0].data =
            abi.encodeCall(VaultLogic.depositERC20, (usdcAddress, 1e6, address(kernel)));

        actions[0].storageRef = "";
        actions[0].initData = "";

        return (checkers, actions);
    }

    function _setAddress() internal {
        kernel = Kernel(
            payable(
                address(
                    factory.createAccount(
                        address(kernelImpl),
                        abi.encodeWithSelector(
                            KernelStorage.initialize.selector,
                            defaultValidator,
                            abi.encodePacked(owner)
                        ),
                        0
                    )
                )
            )
        );
        vm.deal(address(kernel), 10 ether);
    }

    function _fillUserOp(
        IEntryPoint _entryPoint,
        address _sender,
        bytes memory _data
    ) internal view returns (UserOperation memory op) {
        op.sender = _sender;
        op.nonce = _entryPoint.getNonce(_sender, 0);
        op.initCode = "";
        op.callData = _data;
        op.callGasLimit = 10000000;
        op.verificationGasLimit = 10000000;
        op.preVerificationGas = 50000;
        op.maxFeePerGas = 50000;
        op.maxPriorityFeePerGas = 1;
        op.paymasterAndData = bytes("");
    }

    function _signUserOpHash(
        uint256 _key,
        UserOperation memory _op
    ) internal view returns (bytes memory signature) {
        bytes32 hash = entryPoint.getUserOpHash(_op);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_key, ECDSA.toEthSignedMessageHash(hash));
        signature = abi.encodePacked(r, s, v);
    }

    function _performUserOperationWithSig(UserOperation memory op) internal {
        op.signature = abi.encodePacked(bytes4(0x00000000), _signUserOpHash(ownerKey, op));
        // op.signature = _signUserOpHash(ownerKey, op);

        UserOperation[] memory ops = new UserOperation[](1);
        ops[0] = op;
        entryPoint.handleOps(ops, beneficiary);
    }

    function _performUserOperation(UserOperation memory op) internal {
        UserOperation[] memory ops = new UserOperation[](1);
        ops[0] = op;
        entryPoint.handleOps(ops, beneficiary);
    }

    function _getTypedDataHash(
        bytes4 sig,
        uint48 validUntil,
        uint48 validAfter,
        address validator,
        address executor,
        bytes memory enableData
    ) public view returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                ERC4337Utils._buildDomainSeparator(KERNEL_NAME, KERNEL_VERSION, address(kernel)),
                ERC4337Utils.getStructHash(
                    sig, validUntil, validAfter, validator, executor, enableData
                )
            )
        );
    }

    function _initializeDitto() internal {
        poolFee = pool.fee();

        vm.startPrank(donor);
        TransferHelper.safeTransfer(usdcAddress, vaultOwner, 20000e6);
        TransferHelper.safeTransfer(wethAddress, vaultOwner, 10e18);
        TransferHelper.safeTransfer(usdcAddress, address(kernel), 20000e6);
        vm.stopPrank();

        reg = deploySystemContracts(isTest, Registry.contractsByChainId(block.chainid));

        reg.protocolFees = new ProtocolFees(address(kernel));
        reg.logics.executionLogic = address(new ExecutionLogic(reg.protocolFees));

        uint256 nonce = vm.getNonce(address(this));
        reg.vaultProxyAdmin = new VaultProxyAdmin(vm.computeCreateAddress(address(this), nonce + 3));

        (VaultFactory vaultFactory,) = addImplementation(reg, isTest, address(this));

        vm.startPrank(vaultOwner);
        vault = vaultFactory.deploy(1, 1);

        vm.deal(address(kernel), 2 ether);
        vm.deal(vaultOwner, 3 ether);

        TransferHelper.safeApprove(usdcAddress, vault, type(uint256).max);
        TransferHelper.safeApprove(wethAddress, vault, type(uint256).max);

        (, int24 currentTick,,,,,) = pool.slot0();
        int24 minTick = ((currentTick - 4000) / 60) * 60;
        int24 maxTick = ((currentTick + 4000) / 60) * 60;

        uint256 RTarget = reg.lens.dexLogicLens.getTargetRE18ForTickRange(minTick, maxTick, pool);
        uint160 sqrtPriceX96 = reg.lens.dexLogicLens.getCurrentSqrtRatioX96(pool);

        uint256 wethAmount = reg.lens.dexLogicLens.token1AmountForTargetRE18(
            sqrtPriceX96, 500e6, 1e18, RTarget, poolFee
        );

        uint256 usdcAmount =
            reg.lens.dexLogicLens.token0AmountForTargetRE18(sqrtPriceX96, wethAmount, RTarget);

        VaultLogic(vault).depositERC20(wethAddress, wethAmount, vaultOwner);
        VaultLogic(vault).depositERC20(usdcAddress, usdcAmount, vaultOwner);
        vm.stopPrank();

        vm.prank(vault);
        // mint new nft for tests
        nftId = UniswapLogic(vault).uniswapMintNft(
            pool,
            ((currentTick - 4000) / 60) * 60,
            ((currentTick + 4000) / 60) * 60,
            usdcAmount,
            wethAmount,
            false,
            true,
            1e18
        );
    }
}
