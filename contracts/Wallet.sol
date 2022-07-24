//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./project.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract IWallet is PriceConsumerV3 {

    // ERC20 public token;
    uint public stakeTime;
    // uint public initialDeposit;
    uint public investAmount;
    address public owner;
    // uint public currentBalance;

    event Deposit(address caller, uint amount);
    event Stake(address caller, uint amount);
    event Withdraw(address caller, uint amount);
     event WithdrawInvestment(address caller, uint amount);

    mapping(address => uint) accountBalance;
    mapping(address => uint) ibalance;
    mapping(address => uint) currentIBalance;

    constructor() {
       owner = payable (msg.sender);
   }


    function deposit()payable  external {
       require(msg.value >= 1 ether, "invalid amount");
       investAmount = msg.value * 10 / 100 ;
       uint initialDeposit = msg.value - investAmount;
       accountBalance[msg.sender] = accountBalance[msg.sender] + initialDeposit;
       emit Deposit(msg.sender, msg.value);

   }

   function withdraw(uint _amount) external {
       require(msg.sender == owner, "caller is not owner");
       require(_amount <= accountBalance[msg.sender], "invalid amount");
       accountBalance[msg.sender] = accountBalance[msg.sender] - _amount;
       payable(msg.sender).transfer(_amount);
       emit Withdraw(msg.sender, _amount);

   }

    function stake() payable external{
        require(msg.value == investAmount, "invalid amount");
        stakeTime = block.timestamp;
        ibalance[msg.sender] = ibalance[msg.sender] + msg.value;
        emit Stake(msg.sender, msg.value);

    }

    function earn() external returns(uint){
        require(block.timestamp - stakeTime >= 20 seconds , "cant earn now");
        uint interest = ibalance[msg.sender] * 20/100;
         currentIBalance[msg.sender] = ibalance[msg.sender] + interest;
         return currentIBalance[msg.sender];
    }

    function withdrawInvestment(uint amount) external {
        require(block.timestamp - stakeTime >= 20 seconds , "cant withdraw now");
        currentIBalance[msg.sender] = currentIBalance[msg.sender] - amount;
        payable(msg.sender).transfer(amount);
        emit WithdrawInvestment(msg.sender, amount);

    }

    

    function getBalance() external view returns (uint, uint) {
       return (address(this).balance, msg.sender.balance);
   }
}