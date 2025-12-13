// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PriceFeedOracle
 * @notice Chainlink price feed integration for accurate asset pricing
 */
contract PriceFeedOracle {
    struct PriceFeed {
        address feedAddress;
        uint256 heartbeat; // Max acceptable staleness
        uint8 decimals;
        bool active;
    }

    mapping(address => PriceFeed) public priceFeeds;
    address public immutable fallbackOracle;

    uint256 public constant MAX_STALENESS = 24 hours;

    event PriceFeedAdded(address indexed asset, address indexed feed);
    event PriceFeedUpdated(address indexed asset, address indexed newFeed);
    event StalePriceDetected(address indexed asset, uint256 timestamp);

    constructor(address _fallbackOracle) {
        fallbackOracle = _fallbackOracle;
    }

    function addPriceFeed(
        address asset,
        address feed,
        uint256 heartbeat,
        uint8 decimals
    ) external {
        require(asset != address(0) && feed != address(0), "Invalid address");
        require(heartbeat <= MAX_STALENESS, "Heartbeat too long");

        priceFeeds[asset] = PriceFeed({
            feedAddress: feed,
            heartbeat: heartbeat,
            decimals: decimals,
            active: true
        });

        emit PriceFeedAdded(asset, feed);
    }

    function getPrice(address asset) external view returns (uint256 price) {
        PriceFeed memory feed = priceFeeds[asset];
        require(feed.active, "Feed not active");

        // In production: call Chainlink price feed
        // ( , int256 answer, , uint256 updatedAt, ) = AggregatorV3Interface(feed.feedAddress).latestRoundData();

        // For now, return mock price
        price = 1e8; // $1.00 with 8 decimals

        // Check staleness
        // require(block.timestamp - updatedAt <= feed.heartbeat, "Stale price");
    }

    function getPriceWithFallback(address asset)
        external
        view
        returns (uint256 price, bool usedFallback)
    {
        PriceFeed memory feed = priceFeeds[asset];

        if (!feed.active) {
            return (_getFallbackPrice(asset), true);
        }

        // Try primary feed
        try this.getPrice(asset) returns (uint256 p) {
            return (p, false);
        } catch {
            // Use fallback
            return (_getFallbackPrice(asset), true);
        }
    }

    function _getFallbackPrice(address asset) internal view returns (uint256) {
        // Fallback to TWAP or secondary oracle
        // Placeholder
        return 1e8;
    }

    function convertValue(
        address fromAsset,
        address toAsset,
        uint256 amount
    ) external view returns (uint256) {
        uint256 fromPrice = this.getPrice(fromAsset);
        uint256 toPrice = this.getPrice(toAsset);

        return (amount * fromPrice) / toPrice;
    }

    function setPriceFeedActive(address asset, bool active) external {
        priceFeeds[asset].active = active;
    }
}
