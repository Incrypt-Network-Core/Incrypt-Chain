pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";

// INCRYPT Token
contract INCRYPTToken is SafeERC20 {
    mapping(address => uint256) public balanceOf;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    constructor() {
        __ERC20_init("INCRYPT Token", "INCRYPT");
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "balance too low");
        require(to.code.length == 0 || isContract(to), "not a valid address");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    // additional contract functions, such as approve, allowance etc.

}

// Function to check if an address is a contract.
function isContract(address account) internal view returns (bool) {
    uint256 size;

    assembly {
        size := extcodesize(account)
    }

    return size > 0;
}