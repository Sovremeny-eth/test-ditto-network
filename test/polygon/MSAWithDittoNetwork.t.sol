// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import { Test, console2 } from "forge-std/Test.sol";
import { POLYGON_ENTRYPOINT_0_6_0 } from "src/DittoConstants.sol";
import { DittoNetworkExecutor } from "src/DittoNetworkExecutor.sol";

import { IEntryPoint } from "@account-abstraction/contracts/interfaces/IEntryPoint.sol";
import { UserOperation } from "@account-abstraction/contracts/interfaces/UserOperation.sol";
import { MSAAdvanced } from "src/erc7579/MSAAdvanced.sol";
import "src/erc7579/interfaces/IERC7579Module.sol";
import "src/erc7579/interfaces/IERC7579Account.sol";
import "src/erc7579/MSAFactory.sol";
import "solady/utils/ECDSA.sol";
import { BootstrapUtil, BootstrapConfig } from "../erc7579/Bootstrap.t.sol";
import { SimpleExecutionValidator } from "src/erc7579/modules/SimpleExecutionValidator.sol";
import { MockExecutor } from "../erc7579/mocks/MockExecutor.sol";
import { MockTarget } from "../erc7579/mocks/MockTarget.sol";
import { ExecutionLib } from "src/erc7579/lib/ExecutionLib.sol";
import "src/erc7579/lib/ModeLib.sol";
import { IMSA } from "src/erc7579/interfaces/IMSA.sol";

contract MSAWithDittoNetworkTest is BootstrapUtil, Test {
    MSAAdvanced implementation;
    MSAFactory factory;
    IEntryPoint entryPoint = IEntryPoint(POLYGON_ENTRYPOINT_0_6_0);

    SimpleExecutionValidator defaultValidator;
    MockExecutor defaultExecutor;
    DittoNetworkExecutor dittoExecutor;

    MockTarget mockTarget;

    address owner;
    uint256 ownerKey;

    IMSA account;

    function setUp() public {
        vm.createSelectFork(vm.envString("POLYGON_RPC_URL"));
        vm.txGasPrice(80000000000);

        (owner, ownerKey) = makeAddrAndKey("owner");

        implementation = new MSAAdvanced();
        factory = new MSAFactory(address(implementation));

        // Set up Modules
        defaultExecutor = new MockExecutor();
        dittoExecutor = new DittoNetworkExecutor();
        defaultValidator = new SimpleExecutionValidator();

        // target = IUniversalVault(POLYGON_UNIVERSAL_VAULT_ADDRESS);
        mockTarget = new MockTarget();

        bytes memory init = _initializeAccount();
        account = _createAccount(init);

        vm.startPrank(address(account));
        account.installModule(MODULE_TYPE_VALIDATOR, address(defaultValidator), "");
        vm.stopPrank();
    }

    // =========================
    // Run
    // =========================

    function test_first_transaction() external {
        // TODO: When installing the dittoExecutor module should initialized new storage

        bytes memory setValueOnTarget = abi.encodeCall(MockTarget.setValue, 1337);

        bytes memory userOpCalldata = abi.encodeCall(
            IERC7579Account.execute,
            (
                ModeLib.encodeSimpleSingle(),
                ExecutionLib.encodeSingle(address(mockTarget), uint256(0), setValueOnTarget)
            )
        );

        uint256 nonce = _getNonce(address(account), address(defaultValidator));

        UserOperation memory userOp = _getDefaultUserOp();
        userOp.sender = address(account);
        userOp.nonce = nonce;
        userOp.callData = userOpCalldata;

        _performUserOperationWithSig(userOp);

        // OR => because there is no signature check

        // UserOperation[] memory userOps = new UserOperation[](1);
        // userOps[0] = userOp;
        //
        // entryPoint.handleOps(userOps, payable(address(0x69)));
    }

    function test_polygon_register_workflow() external { }

    // =========================
    // Helpers
    // =========================

    function _initializeAccount() internal returns (bytes memory init) {
        BootstrapConfig[] memory validators =
            makeBootstrapConfig(address(defaultValidator), abi.encodePacked(owner));
        BootstrapConfig[] memory executors = new BootstrapConfig[](2);
        executors[0] = makeBootstrapConfig(address(defaultExecutor), "")[0];
        executors[1] = makeBootstrapConfig(address(dittoExecutor), "")[0];
        BootstrapConfig memory hook = _makeBootstrapConfig(address(0), "");
        BootstrapConfig[] memory fallbacks = makeBootstrapConfig(address(0), "");

        init = abi.encode(
            address(bootstrapSingleton),
            abi.encodeCall(bootstrapSingleton.initMSA, (validators, executors, hook, fallbacks))
        );
    }

    function _createAccount(bytes memory initCode) internal returns (IMSA _account) {
        bytes32 salt = keccak256("1");

        _account = IMSA(payable(address(factory.createAccount(salt, initCode))));

        vm.deal(address(_account), 100 ether);
    }

    function _getNonce(address _account, address validator) internal returns (uint256 nonce) {
        uint192 key = uint192(bytes24(bytes20(address(validator))));
        nonce = entryPoint.getNonce(address(_account), key);
    }

    function _getDefaultUserOp() internal returns (UserOperation memory userOp) {
        userOp = UserOperation({
            sender: address(0),
            nonce: 0,
            initCode: "",
            callData: "",
            callGasLimit: 10000000,
            verificationGasLimit: 10000000,
            preVerificationGas: 50000,
            maxFeePerGas: 50000,
            maxPriorityFeePerGas: 1,
            paymasterAndData: bytes(""),
            signature: bytes("")
        });
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
        entryPoint.handleOps(ops, payable(address(0x69)));
    }
}
