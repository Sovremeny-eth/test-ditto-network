pragma solidity ^0.8.0;

import { IEntryPoint } from "I4337/interfaces/IEntryPoint.sol";
import { UserOperation } from "I4337/interfaces/UserOperation.sol";
import { ECDSA } from "solady/utils/ECDSA.sol";
import { Kernel } from "../Kernel.sol";
import { IKernelValidator } from "../interfaces/IKernelValidator.sol";
import { ValidationData } from "../common/Types.sol";
import { SIG_VALIDATION_FAILED, KERNEL_STORAGE_SLOT_1 } from "../common/Constants.sol";
import { ExecutionDetail } from "../common/Structs.sol";
import { packValidationData } from "../common/Types.sol";
import { _intersectValidationData } from "../utils/KernelHelper.sol";

struct KernelLiteECDSAStorage {
    address owner;
}

/// @title KernelLiteECDSA Contract
/// @dev A lite version of the Kernel contract which only uses ECDSA signatures for validation
contract KernelLiteECDSA is Kernel {
    error InvalidAccess();
    error InvalidValidator();

    address public immutable KERNEL_ECDSA_VALIDATOR;

    /// @dev The storage slot for this contract
    bytes32 private constant KERNEL_LITE_ECDSA_STORAGE_SLOT =
        0xdea7fea882fba743201b2aeb1babf326b8944488db560784858525d123ee7e97; // keccak256(abi.encodePacked("zerodev.kernel.lite.ecdsa"))
        // - 1

    constructor(IEntryPoint _entryPoint, IKernelValidator _ecdsaValidator) Kernel(_entryPoint) {
        KERNEL_ECDSA_VALIDATOR = address(_ecdsaValidator);
        getKernelLiteECDSAStorage().owner = address(1); // set owner to non-zero address to prevent
            // initialization
    }

    /// @dev Transfer the ownership of this current kernel
    function transferOwnership(address _newOwner) external payable onlyFromEntryPointOrSelf {
        getKernelLiteECDSAStorage().owner = _newOwner;
    }

    // FOR KERNEL USAGE
    function getKernelLiteECDSAStorage() internal pure returns (KernelLiteECDSAStorage storage s) {
        assembly {
            s.slot := KERNEL_LITE_ECDSA_STORAGE_SLOT
        }
    }

    /// @dev Set the initial data for this kernel (setup ecdsa signer address)
    function _setInitialData(IKernelValidator _validator, bytes calldata _data) internal override {
        // Ensure the validator is valid
        if (address(_validator) != KERNEL_ECDSA_VALIDATOR) {
            revert InvalidValidator();
        }
        // Ensure the account isn't already initialized
        if (getKernelLiteECDSAStorage().owner != address(0)) {
            revert AlreadyInitialized();
        }

        address owner = address(bytes20(_data[0:20]));
        getKernelLiteECDSAStorage().owner = owner;
    }

    /// @dev Validate a user operation
    function _validateUserOp(
        UserOperation calldata _op,
        bytes32 _opHash,
        uint256
    ) internal view override returns (ValidationData) {
        address signed = ECDSA.recover(ECDSA.toEthSignedMessageHash(_opHash), _op.signature[4:]); // note
            // that first 4 bytes are for modes
        if (signed != getKernelLiteECDSAStorage().owner) {
            return SIG_VALIDATION_FAILED;
        }
        return ValidationData.wrap(0);
    }

    /// @dev Validate a signature
    function _validateSignature(
        address, /*_requestor*/
        bytes32 _hash,
        bytes32, /*_rawHash*/
        bytes calldata _signature
    ) internal view override returns (ValidationData) {
        address signed = ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
        if (signed == getKernelLiteECDSAStorage().owner) {
            return ValidationData.wrap(0);
        }
        return SIG_VALIDATION_FAILED;
    }

    /// @dev Check if the caller is valid
    function _validCaller(address _caller, bytes calldata) internal view override returns (bool) {
        return _caller == getKernelLiteECDSAStorage().owner;
    }

    function setDefaultValidator(
        IKernelValidator,
        bytes calldata
    ) external payable override onlyFromEntryPointOrSelf {
        revert("not implemented");
    }
}
