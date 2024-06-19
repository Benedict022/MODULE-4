// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Alcantara is ERC20 {
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
    mapping(address => bool) public frozenAccounts;

    event Freeze(address indexed account);
    event Unfreeze(address indexed account);

    constructor(address _owner) ERC20("Degen", "DGN") {
        require(_owner != address(0), "Owner address cannot be the zero address");
        owner = _owner;

        itemsList.push(Item(0, "Blessing of the Welkin Moon", 50, 50));
        itemsList.push(Item(1, "Gnostic Chorus", 60, 50));
        itemsList.push(Item(2, "Ganyu: Twilight Blossom Skin", 150, 10));
        itemsList.push(Item(3, "Jean: Sea Breeze Dandelion Skin", 200, 5));
        itemsList.push(Item(4, "Diluc: Red Dead of the Night Skin", 500, 1));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier notFrozen(address account) {
        require(!frozenAccounts[account], "Account is frozen");
        _;
    }

    function freezeAccount(address account) public onlyOwner {
        frozenAccounts[account] = true;
        emit Freeze(account);
    }

    function unfreezeAccount(address account) public onlyOwner {
        frozenAccounts[account] = false;
        emit Unfreeze(account);
    }

    function mint(address account, uint256 amount) public onlyOwner notFrozen(account) {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public notFrozen(account) {
        require(amount > 0, "Burn amount must be greater than zero");
        require(account != address(0), "Account address cannot be the zero address");
        require(balanceOf(account) >= amount, "Insufficient balance to burn");
        _burn(account, amount);
    }

    function transfer(address recipient, uint256 amount) public override notFrozen(msg.sender) notFrozen(recipient) returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");
        return super.transfer(recipient, amount);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function Purchased_Items(address account) public view returns (Item[] memory) {
        return RedeemedItemsList[account];
    }

    function redeem(uint256 itemId, address account) public notFrozen(account) {
        require(itemId < itemsList.length, "Invalid item ID");
        Item storage item = itemsList[itemId];
        require(balanceOf(account) >= item.cost, "Insufficient balance to redeem item");
        require(item.supply > 0, "Item is out of stock");
        require(account != address(0), "Account address cannot be the zero address");

        burn(account, item.cost);
        RedeemedItemsList[account].push(item);
        item.supply--;
    }
}
