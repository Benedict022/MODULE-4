# BUILDING ON AVALANCHE

For the last module the task for this mint, redeem, transger and check balance of the player or user

# DESCRIPTION
Require is a term for a requirement that must be fulfilled for the function to proceed. If the condition evaluates to false, the function will rerun with all state alterations made during the execution undone. Assert: This verb is used to look for circumstances that don't have to be evaluated as false. It is usually used to look for internal problems or static circumstances. To reverse the current transaction and display an optional error message, use the "Revert" command.

# GETTING STARTED
To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a functionanderrors.sol extension (e.g., functionanderrors.sol). Copy and paste the following code into the file:

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
# AUTHOR
Alcantara, John Benedict G. Bsit 3.1
