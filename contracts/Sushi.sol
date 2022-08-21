//  SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Sushi is ReentrancyGuard, ERC20("Sushi", "xSUSHI") {
    using SafeMath for uint256;
    IERC20 public sushi;

    constructor(IERC20 _sushi) {
        sushi = _sushi;
    }

    struct SushiStake {
        uint256 startTS;
        uint256 amount;
        address owner;
        bool isStaked;
    }

    mapping (address => SushiStake) public stakes;

    event Staked(address indexed _owner, uint256 _amount);

    function enter(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");
        if (_amount > 0) {
            _mint(msg.sender, _amount);
            sushi.transferFrom(msg.sender, address(this), _amount);
            stakes[msg.sender] = SushiStake({
                startTS: block.timestamp,
                amount: _amount,
                owner: msg.sender,
                isStaked: true
            });
        }
    }

    function leave() public {
        require(stakes[msg.sender].isStaked == true, "You are not staking");

        uint256 totalStaked = sushi.balanceOf(msg.sender);

        if ( stakes[msg.sender].startTS > (block.timestamp) && stakes[msg.sender].startTS <= (block.timestamp + 2 days) ) {
            uint256 unStakeAble = totalStaked.div(100).mul(0);
            sushi.transfer(msg.sender, unStakeAble);
            sushi.transferFrom(address(this), msg.sender, totalStaked.sub(unStakeAble));
        }
        else if ( stakes[msg.sender].startTS > (block.timestamp + 2 days) && stakes[msg.sender].startTS <= (block.timestamp + 4 days) ) {
            uint256 unStakeAble = totalStaked.div(100).mul(25);
            sushi.transfer(msg.sender, unStakeAble);
            sushi.transferFrom(address(this), msg.sender, totalStaked.sub(unStakeAble));
        }
        else if ( stakes[msg.sender].startTS > (block.timestamp + 4 days) && stakes[msg.sender].startTS <= (block.timestamp + 6 days) ) {
            uint256 unStakeAble = totalStaked.div(100).mul(50);
            sushi.transfer(msg.sender, unStakeAble);
            sushi.transferFrom(address(this), msg.sender, totalStaked.sub(unStakeAble));
        }
        else if ( stakes[msg.sender].startTS > (block.timestamp + 6 days) && stakes[msg.sender].startTS <= (block.timestamp + 8 days) ) {
            uint256 unStakeAble = totalStaked.div(100).mul(75);
            sushi.transfer(msg.sender, unStakeAble);
            sushi.transferFrom(address(this), msg.sender, totalStaked.sub(unStakeAble));
        }
        else {
            sushi.transfer(msg.sender, totalStaked);
        }
    }
}