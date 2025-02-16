// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { BaseContract } from "../../../libraries/BaseContract.sol";

import { ICelerCircleBridge } from "../../../interfaces/external/ICelerCircleBridge.sol";
import { ICelerCircleBridgeLogic } from
    "../../../interfaces/ourLogic/bridges/ICelerCircleBridgeLogic.sol";

import { AccessControlLib } from "../../../libraries/AccessControlLib.sol";

contract CelerCircleBridgeLogic is ICelerCircleBridgeLogic, BaseContract {
    // =========================
    // Constructor
    // =========================

    ICelerCircleBridge private immutable celerCircleProxy;
    IERC20 private immutable usdc;

    constructor(address _celerCircleProxy, address _usdc) {
        celerCircleProxy = ICelerCircleBridge(_celerCircleProxy);
        usdc = IERC20(_usdc);
    }

    // =========================
    // Main functions
    // =========================

    /// @inheritdoc ICelerCircleBridgeLogic
    function sendCelerCircleMessage(
        uint64 dstChainId,
        uint256 exactAmount,
        address recipient
    ) external onlyVaultItself {
        usdc.approve(address(celerCircleProxy), exactAmount);

        _sendCelerCircle(dstChainId, exactAmount, recipient);
    }

    /// @inheritdoc ICelerCircleBridgeLogic
    function sendBatchCelerCircleMessage(
        uint64 dstChainId,
        uint256[] calldata exactAmounts,
        address[] calldata recipient
    ) external onlyVaultItself {
        if (exactAmounts.length != recipient.length) {
            revert CelerCircleBridgeLogic_MultisenderArgsNotValid();
        }

        // approve total amount to celerCircleProxy contract
        uint256 totalAmount;
        for (uint256 i; i < exactAmounts.length;) {
            unchecked {
                totalAmount += exactAmounts[i];
                ++i;
            }
        }

        usdc.approve(address(celerCircleProxy), totalAmount);

        for (uint256 i; i < recipient.length;) {
            _sendCelerCircle(dstChainId, exactAmounts[i], recipient[i]);

            unchecked {
                ++i;
            }
        }
    }

    // =========================
    // Private functions
    // =========================

    /// @dev Handles the deposit process for burning tokens via the CelerCircle bridge.
    /// @dev This is a helper function to interact with the CelerCircle bridge's depositForBurn
    /// method.
    /// @param dstChainId The destination chain ID where the tokens will be burned.
    /// @param exactAmount The exact amount of tokens to be sent for burning.
    /// @param recipient The recipient address on the destination chain.
    function _sendCelerCircle(uint64 dstChainId, uint256 exactAmount, address recipient) private {
        celerCircleProxy.depositForBurn(
            exactAmount, dstChainId, bytes32(uint256(uint160(recipient))), address(usdc)
        );
    }
}
