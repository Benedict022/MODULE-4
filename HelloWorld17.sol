// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Module4Degen is ERC20 {
    address public owner;

    struct Item {
        uint256 itemId;
        string name;
        uint256 cost;
        uint256 supply;
    }

    struct User {
        uint256 membershipLevel;
    }

    Item[] public itemsList;
    mapping(address => Item[]) public RedeemedItemsList;
    mapping(address => User) public users;

    constructor(address _owner) ERC20("Degen", "DGN") {
        require(_owner != address(0), "Owner address cannot be the zero address");
        owner = _owner;

        //Genshin Skin [itemID, itemName, itemCost, itemStock]
        itemsList.push(Item(0, "Blessing of the Welkin Moon", 50, 50));
        itemsList.push(Item(1, "Gnostic Chorus", 60, 50));
        itemsList.push(Item(2, "Ganyu: Twilight Blossom Skin", 150, 10));
        itemsList.push(Item(3, "Jean: Sea Breeze Dandelion Skin", 200, 5));
        itemsList.push(Item(4, "Diluc: Red Dead of the Night Skin", 500, 3));
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

    function Purchased_Items(address account) public view returns (Item[] memory) {
        return RedeemedItemsList[account];
    }

    function redeem(uint256 itemId, address account) public {
        require(itemId < itemsList.length, "Invalid item ID");
        Item storage item = itemsList[itemId];
        require(balanceOf(account) >= item.cost, "Insufficient balance to redeem item");
        require(item.supply > 0, "Item is out of stock");
        require(account != address(0), "Account address cannot be the zero address");

        _transfer(account, owner, item.cost);
        RedeemedItemsList[account].push(item);
        item.supply--;
    }

    function Upgrade_Membership(address account) public {
        require(account != address(0), "Account address cannot be the zero address");
        require(balanceOf(account) >= 100, "Insufficient balance to upgrade membership");
        
        _transfer(account, owner, 100);
        users[account].membershipLevel++;
    }

    function Apply_Discount(uint256 itemId, address account) public view returns (uint256) {
        require(itemId < itemsList.length, "Invalid item ID");
        Item memory item = itemsList[itemId];
        User memory user = users[account];

        if (user.membershipLevel == 1) {
            return item.cost * 90 / 100; // 10% discount
        } else if (user.membershipLevel == 2) {
            return item.cost * 80 / 100; // 20% discount
        } else {
            return item.cost;
        }
    }
}
