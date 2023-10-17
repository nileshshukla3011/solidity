// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract VDOITToken is ERC20, Ownable {
    using SafeMath for uint256;
    uint256 private constant INITIAL_SUPPLY = 100000 * 10**18; // 100,000 tokens with 18 decimal places
    uint256 private lockedAmount = 24000 * 10**18; // 24,000 tokens with 18 decimal places
    uint256 private constant RELEASE_PERIOD = 30 days; // 1 month in seconds
    uint256 private constant RELEASE_AMOUNT = 100 * 10**18; // 100 tokens with 18 decimal places

    uint256 public startTime;
    uint256 public lastReleaseTime;

    constructor() ERC20("VDOIT TOKEN", "VDOIT") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY);
        startTime = block.timestamp;
        lastReleaseTime = startTime;
    }

    function mint(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }

    function releaseTokens() public onlyOwner {
        require(block.timestamp >= lastReleaseTime + RELEASE_PERIOD, "Release period has not passed yet");
        require(lockedAmount > 0, "All locked tokens have been released");
        uint256 currentRelease = block.timestamp.sub(lastReleaseTime).div(RELEASE_PERIOD).mul(RELEASE_AMOUNT);
        if (currentRelease > lockedAmount) {
            currentRelease = lockedAmount;
        }
        _mint(msg.sender, currentRelease);
        lastReleaseTime = lastReleaseTime.add(RELEASE_PERIOD);
        lockedAmount = lockedAmount.sub(currentRelease);
    }
}