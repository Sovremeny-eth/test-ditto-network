// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import { Test, console2 } from "forge-std/Test.sol";
import { IUniversalVault } from "script/polygon/IUniversalVault.sol";
import { POLYGON_ENTRYPOINT_0_6_0, POLYGON_UNIVERSAL_VAULT_ADDRESS } from "src/DittoConstants.sol";
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

contract KernelWithDittoNetworkTest is Test {
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
        executionSig = DittoNetworkExecutor.executeDelegateCall.selector;
        executionDetail.validator = new TestValidator();

        // console2.log(address(owner).balance);
    }

    // =========================
    // Run
    // =========================

    function test_polygon_default_validator_enable() external {
        // TODO: check

        UserOperation memory op = _fillUserOp(
            entryPoint,
            address(kernel),
            abi.encodeWithSelector(
                IKernel.execute.selector,
                address(defaultValidator),
                0,
                abi.encodeWithSelector(
                    ECDSAValidator.enable.selector, abi.encodePacked(address(0xdeadbeef))
                ),
                Operation.Call
            )
        );
        _performUserOperationWithSig(op);
        (address owner_) =
            ECDSAValidator(address(defaultValidator)).ecdsaValidatorStorage(address(kernel));
        assertEq(owner_, address(0xdeadbeef), "owner should be 0xdeadbeef");
    }

    // =========================
    // Helpers
    // =========================

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

        UserOperation[] memory ops = new UserOperation[](1);
        ops[0] = op;
        entryPoint.handleOps(ops, beneficiary);
    }

    function _performUserOperation(UserOperation memory op) internal {
        UserOperation[] memory ops = new UserOperation[](1);
        ops[0] = op;
        entryPoint.handleOps(ops, beneficiary);
    }
}
