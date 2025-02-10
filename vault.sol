// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract InsecureVault {
    mapping(address => uint256) private balances;
    address public owner;
    uint256 public fee;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
        fee = 0.01 ether;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        balances[msg.sender] -= amount;
        emit Withdrawal(msg.sender, amount);
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function setFee(uint256 newFee) external {
        fee = newFee;
    }

    function executeDelegate(address target, bytes calldata data) external payable returns (bytes memory) {
        (bool success, bytes memory result) = target.delegatecall(data);
        require(success, "Delegatecall failed");
        return result;
    }

    function destroy() external {
        selfdestruct(payable(msg.sender));
    }

    function changeOwner(address newOwner) external {
        owner = newOwner;
    }
}
