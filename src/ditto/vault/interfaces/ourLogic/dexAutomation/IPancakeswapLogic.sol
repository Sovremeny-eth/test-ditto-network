// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IUniswapV3Pool } from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

/// @title IPancakeswapLogic - PancakeswapLogic interface.
interface IPancakeswapLogic {
    // =========================
    // Events
    // =========================

    /// @notice Emits when auto-compounding is executed for a Pancakeswap position.
    /// @param nftId The NFT ID of the position.
    event PancakeswapAutoCompound(uint256 nftId);

    /// @notice Emits when the tick range of a Pancakeswap position is changed.
    /// @param oldNftId The NFT ID of the previous position.
    /// @param newNftId The NFT ID of the new position after changing the tick range.
    event PancakeswapChangeTickRange(uint256 oldNftId, uint256 newNftId);

    /// @notice Emits when a new NFT representing a Pancakeswap position is minted.
    /// @param nftId The NFT ID of the minted position.
    event PancakeswapMintNft(uint256 nftId);

    /// @notice Emits when liquidity is added to a Pancakeswap position.
    /// @param nftId The NFT ID of the position.
    event PancakeswapAddLiquidity(uint256 nftId);

    /// @notice Emits when liquidity is withdrawn from a Pancakeswap position.
    /// @param nftId The NFT ID of the position.
    event PancakeswapWithdraw(uint256 nftId);

    // =========================
    // Main functions
    // =========================

    /// @notice Changes the tick range of a position in Pancakeswap.
    /// @dev Burns previous NFT and mints the new one with provided tick range.
    /// @param newLowerTick The new lower tick.
    /// @param newUpperTick The new upper tick.
    /// @param nftId The ID of the NFT representing the position.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    /// @return Returns the new NFT ID after the change.
    function pancakeswapChangeTickRange(
        int24 newLowerTick,
        int24 newUpperTick,
        uint256 nftId,
        uint256 deviationThresholdE18
    ) external returns (uint256);

    /// @notice Mints a new NFT representing a Pancakeswap position.
    /// @param pancakeswapPool The Pancakeswap pool instance.
    /// @param newLowerTick The lower tick of the position.
    /// @param newUpperTick The upper tick of the position.
    /// @param token0Amount Exact amount of token0 to be transferred from the vault.
    /// @param token1Amount Exact amount of token1 to be transferred from the vault.
    /// @param useFullTokenBalancesFromVault Whether to use all available assets from the vault for
    /// the position.
    /// @param swap Whether to use the swap method for asset adjustment before adding liquidity.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    /// @return Returns the ID of the newly minted NFT.
    function pancakeswapMintNft(
        IUniswapV3Pool pancakeswapPool,
        int24 newLowerTick,
        int24 newUpperTick,
        uint256 token0Amount,
        uint256 token1Amount,
        bool useFullTokenBalancesFromVault,
        bool swap,
        uint256 deviationThresholdE18
    ) external returns (uint256);

    /// @notice Adds liquidity to an existing Pancakeswap position.
    /// @param nftId The ID of the NFT representing the position.
    /// @param token0Amount Exact amount of token0 to be transferred from the vault.
    /// @param token1Amount Exact amount of token1 to be transferred from the vault.
    /// @param useFullTokenBalancesFromVault Whether to use all available assets from
    ///        the vault for the position.
    /// @param swap Whether to use the swap method for asset adjustment before adding liquidity.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    function pancakeswapAddLiquidity(
        uint256 nftId,
        uint256 token0Amount,
        uint256 token1Amount,
        bool useFullTokenBalancesFromVault,
        bool swap,
        uint256 deviationThresholdE18
    ) external;

    /// @notice Collects fees and adds them as liquidity to the position.
    /// @param nftId The ID of the NFT representing the position.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    function pancakeswapAutoCompound(uint256 nftId, uint256 deviationThresholdE18) external;

    /// @notice Executes a swap on dex with exact input amount for a `tokens[0]`.
    /// @param tokens Addresses of the tokens for swap.
    /// @param poolFees Fee tiers array of the pools.
    /// @param amountIn Exact amount of input token to swap.
    /// @param useFullBalanceOfTokenInFromVault Whether to use the full balance of
    ///        the input token from the vault.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    /// @return amountOut Returns the amount of the output token.
    function pancakeswapSwapExactInput(
        address[] calldata tokens,
        uint24[] calldata poolFees,
        uint256 amountIn,
        bool useFullBalanceOfTokenInFromVault,
        bool unwrapInTheEnd,
        uint256 deviationThresholdE18
    ) external returns (uint256 amountOut);

    /// @notice Executes a swap on Pancakeswap with exact output for a `tokenOut`.
    /// @param tokenIn Address of the input token.
    /// @param tokenOut Address of the output token.
    /// @param poolFee Fee tier of the pool.
    /// @param amountOut Exact amount of output token desired.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    /// @return amountIn Returns the amount of the input token spent.
    function pancakeswapSwapExactOutputSingle(
        address tokenIn,
        address tokenOut,
        uint24 poolFee,
        uint256 amountOut,
        uint256 deviationThresholdE18
    ) external returns (uint256 amountIn);

    /// @notice Swaps tokens to achieve a target ratio (R) for pool liquidity.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    /// @param pancakeswapPool The Pancakeswap pool to interact with.
    /// @param token0Amount Amount of token0.
    /// @param token1Amount Amount of token1.
    /// @param targetRE18 Target reserve ratio.
    /// @return Returns the amounts of token0 and token1 after the swap.
    function pancakeswapSwapToTargetR(
        uint256 deviationThresholdE18,
        IUniswapV3Pool pancakeswapPool,
        uint256 token0Amount,
        uint256 token1Amount,
        uint256 targetRE18
    ) external returns (uint256, uint256);

    /// @notice Withdraws liquidity from a Pancakeswap position based on shares.
    /// @param nftId The ID of the NFT representing the position.
    /// @param sharesE18 Amount of shares to determine the amount of liquidity to withdraw.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    function pancakeswapWithdrawPositionByShares(
        uint256 nftId,
        uint128 sharesE18,
        uint256 deviationThresholdE18
    ) external;

    /// @notice Withdraws a specified amount of liquidity from a Pancakeswap position.
    /// @param nftId The ID of the NFT representing the position.
    /// @param liquidity Amount of liquidity to withdraw.
    /// @param deviationThresholdE18 Maximum allowed spotPrice deviation from the oracle price.
    function pancakeswapWithdrawPositionByLiquidity(
        uint256 nftId,
        uint128 liquidity,
        uint256 deviationThresholdE18
    ) external;

    /// @notice Collects fees accumulated in a Pancakeswap position.
    /// @param nftId The ID of the NFT representing the position.
    function pancakeswapCollectFees(uint256 nftId) external;
}
