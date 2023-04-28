// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "./IERC20.sol";

contract ERC20 is IERC20 {

    address public owner;
    string public constant name = "BoGreen";
    string public constant symbol = "BOG";
    uint256 public constant decimals = 18;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    mapping(address => uint256) balance;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 private totalSupply_;

    constructor(uint256 _totalSupply) {
        totalSupply_ = _totalSupply;
        balance[msg.sender] = _totalSupply;
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) private onlyOwner {
        require(_newOwner != address(0), "New owner cannot be zero");
        require(_newOwner != owner, "New owner cannot be current owner");
        owner = _newOwner;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address _account) public view returns (uint256) {
        return balance[_account];
    }

    function allowance(address _owner, address _spender)
        public
        view
        onlyOwner
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    function transfer(address recipient, uint256 amount) public  onlyOwner returns (bool) {
        balance[msg.sender] -= amount;
        balance[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public  onlyOwner returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public  onlyOwner returns (bool) {
        allowed[sender][msg.sender] -= amount;
        balance[sender] -= amount;
        balance[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
