// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { AccessControlLib } from "../libraries/AccessControlLib.sol";
import { BaseContract } from "../libraries/BaseContract.sol";

import { IAccessControlLogic } from "../interfaces/IAccessControlLogic.sol";

/// @title AccessControlLogic.
/// @title Logic for managing roles and permissions.
contract AccessControlLogic is IAccessControlLogic, BaseContract {
    // =========================
    // Main functions
    // =========================

    /// @inheritdoc IAccessControlLogic
    function initializeCreatorAndId(address creator, uint16 vaultId) external {
        AccessControlLib.initializeCreatorAndId(creator, vaultId);
    }

    /// @inheritdoc IAccessControlLogic
    function creatorAndId() external view returns (address, uint16) {
        return AccessControlLib.getCreatorAndId();
    }

    /// @inheritdoc IAccessControlLogic
    function owner() external view returns (address) {
        return AccessControlLib.getOwner();
    }

    /// @notice If this smart-contract is an owner of other contract - this contract must implement
    /// ERC1271 method.
    ///      In case of multisig, signature can be several concatenated signatures
    ///      If owner is EOA, perform a regular ecrecover.
    /// @param dataHash 32 bytes hash of the data signed
    /// @param signature Signature byte array associated with dataHash
    /// @return bytes4 value.
    function isValidSignature(
        bytes32 dataHash,
        bytes calldata signature
    ) external view returns (bytes4) {
        return AccessControlLib.isValidSignature(dataHash, signature)
            ? AccessControlLib.EIP1271_MAGIC_VALUE
            : bytes4(0xffffffff);
    }

    /// @inheritdoc IAccessControlLogic
    function getVaultProxyAdminAddress() external view returns (address proxyAdminAddress) {
        bytes memory bytecode = address(this).code;

        assembly ("memory-safe") {
            proxyAdminAddress := mload(add(bytecode, 32))
        }
    }

    /// @inheritdoc IAccessControlLogic
    function transferOwnership(address newOwner) external onlyOwnerOrVaultItself {
        AccessControlLib.RolesStorage storage s = AccessControlLib.rolesStorage();

        address oldOwner;
        if (!s.useOwner) {
            s.useOwner = true;
            oldOwner = s.creator;
        } else {
            oldOwner = s.owner;
        }

        s.owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /// @inheritdoc IAccessControlLogic
    function setCrossChainLogicInactiveStatus(bool newValue) external onlyVaultItself {
        AccessControlLib.RolesStorage storage s = AccessControlLib.rolesStorage();

        s.crossChainLogicInactive = newValue;

        emit CrossChainLogicInactiveFlagSet(newValue);
    }

    /// @inheritdoc IAccessControlLogic
    function crossChainLogicIsActive() external view returns (bool) {
        return AccessControlLib.crossChainLogicIsActive();
    }

    /// @inheritdoc IAccessControlLogic
    function hasRole(bytes32 role, address account) external view returns (bool) {
        AccessControlLib.RolesStorage storage s = AccessControlLib.rolesStorage();
        return _hasRole(s, role, account);
    }

    /// @inheritdoc IAccessControlLogic
    function grantRole(bytes32 role, address account) external onlyOwnerOrVaultItself {
        _grantRole(role, account);
    }

    /// @inheritdoc IAccessControlLogic
    function revokeRole(bytes32 role, address account) external onlyOwnerOrVaultItself {
        _revokeRole(role, account);
    }

    /// @inheritdoc IAccessControlLogic
    function renounceRole(bytes32 role) external {
        _revokeRole(role, msg.sender);
    }

    // =========================
    // Private functions
    // =========================

    /// @dev Grants a `role` to an `account` internally.
    /// @param role Role identifier to grant.
    /// @param account Address of the account to grant the role to.
    function _grantRole(bytes32 role, address account) private {
        AccessControlLib.RolesStorage storage s = AccessControlLib.rolesStorage();
        if (!_hasRole(s, role, account)) {
            s.roles[role][account] = true;
            emit RoleGranted(role, account, msg.sender);
        }
    }

    /// @dev Revokes a `role` from an `account` internally.
    /// @param role Role identifier to revoke.
    /// @param account Address of the account to revoke the role from.
    function _revokeRole(bytes32 role, address account) private {
        AccessControlLib.RolesStorage storage s = AccessControlLib.rolesStorage();
        if (_hasRole(s, role, account)) {
            s.roles[role][account] = false;
            emit RoleRevoked(role, account, msg.sender);
        }
    }
}
