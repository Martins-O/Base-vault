// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title VaultNFT
 * @notice NFT receipts for vault positions
 */
contract VaultNFT is ERC721 {
    uint256 public nextTokenId;

    struct Position {
        uint256 shares;
        uint256 depositTime;
        address vault;
    }

    mapping(uint256 => Position) public positions;

    constructor() ERC721("BaseVault Position", "BVP") {}

    function mint(address to, uint256 shares, address vault) external returns (uint256) {
        uint256 tokenId = nextTokenId++;
        _mint(to, tokenId);

        positions[tokenId] = Position({
            shares: shares,
            depositTime: block.timestamp,
            vault: vault
        });

        return tokenId;
    }
}
