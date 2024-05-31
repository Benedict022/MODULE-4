// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Alcantara is ERC20 {
    address public owner;

    struct Item {
        string name;
        uint256 cost;
    }

    Item[] public itemsList;
    mapping(address => Item[]) public redeemedItems;

    constructor(address _owner) ERC20("Degen", "DGN") {
        require(_owner != address(0), "Owner address cannot be the zero address");
        owner = _owner;

        itemsList.push(Item("cheese burger", 50));
        itemsList.push(Item("double cheese burger", 60));
        itemsList.push(Item("quarter pounder", 150));
        itemsList.push(Item("Mc Chicken sandwich", 52));
        itemsList.push(Item("Burger Mc", 40));
    }

    function mint(address account, uint256 amount) public {
        require(msg.sender == owner, "Only the owner can use this mint function");
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public {
        require(amount > 0, "Burn amount must be greater than zero");
        require(account != address(0), "Account address cannot be the zero address");
        require(balanceOf(account) >= amount, "Insufficient balance to burn");
        _burn(account, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");
        return super.transfer(recipient, amount);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function getPurchasedItems(address account) public view returns (Item[] memory) {
        return redeemedItems[account];
    }

    function redeem(uint256 itemId, address account) public {
        require(itemId < itemsList.length, "Invalid item ID");
        Item memory item = itemsList[itemId];
        require(balanceOf(account) >= item.cost, "Insufficient balance to redeem item");
        require(account != address(0), "Account address cannot be the zero address");

        burn(account, item.cost);
        redeemedItems[account].push(item);
    }
}