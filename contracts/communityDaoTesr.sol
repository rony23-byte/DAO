// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract UbuntuTokens is ERC20 {
    address owner;

    constructor() ERC20("UbuntuDao", "UD") {
        owner = msg.sender;
    }

    //modifier
    modifier onlyTheOwner() {
        require(msg.sender == owner, "only the owner can mint");
        _;
    }

    //function mint
    function mintTokens(
        address addressToMint,
        uint amountToMint
    ) public onlyTheOwner {
        _mint(addressToMint, amountToMint * 10 ** 18);
    }
}
