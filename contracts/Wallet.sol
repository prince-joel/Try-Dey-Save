//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract IWallet  {
    event Deposit(address caller, uint amount);
    event Invest( uint amount);
    event Withdraw(address caller, uint amount);
    event WithdrawInvestment(address caller, uint amount);
    // uint public GeninvestAmount;

    struct Users{
        address owner;
        uint  accountBalance;
        uint  currentIBalance;
        uint investAmount;
        bool hasEarned;
        uint investTime;
    }
 
    constructor() public {

    }

    mapping(address => Users) public user;
    

    function deposit()payable  external {
       invest(msg.value);       
       emit Deposit(msg.sender, msg.value);
   }

   function withdraw(uint _amount) external {
       Users storage user1 = user[msg.sender];
       user1.owner = msg.sender;
    //    require(user1.owner == msg.sender, "caller is not owner");
       require(user1.accountBalance >= _amount, "invalid amount");
       user1.accountBalance = user1.accountBalance - _amount;
       payable(msg.sender).transfer(_amount);
       emit Withdraw(msg.sender, _amount);

   }

    function invest(uint _amount) internal{
        Users storage user1 = user[msg.sender];
        // require(user1.investAmount, "invalid amount");
        require(_amount >= 1 ether, "invalid amount");
       user1.investAmount = _amount * 10 / 100 ;
       uint initialDeposit = _amount - user1.investAmount;
       user1.owner = msg.sender; 
       user1.accountBalance += initialDeposit; 
       user1.currentIBalance += user1.investAmount;
        user1.investTime = block.timestamp;
        // user1.currentIBalance = user1.currentIBalance + _amount;
        user1.hasEarned = false;
        emit Invest( _amount);

    }

    function earn() external returns(bool){
        Users storage user1 = user[msg.sender];
        require(user1.hasEarned == false, "cant earn again");
        require(block.timestamp - user1.investTime >= 20 seconds , "cant earn now");
        uint interest = user1.investAmount * 20/100;
        user1.currentIBalance += interest;
        user1.hasEarned = true;
        return true;
    }

//         // require(block.timestamp - investTime >= 20 seconds , "cant withdraw now");
    function withdrawInvestment(uint amount) external {
        Users storage user1 = user[msg.sender];
        require(user1.hasEarned == true, "have not earned yet");
        require(amount <= user1.currentIBalance, "invalid amount");
        user1.currentIBalance = user1.currentIBalance - amount;
        user1.accountBalance = user1.accountBalance + amount;    
        payable(msg.sender).transfer(amount);
        emit WithdrawInvestment(msg.sender, amount);
    }

}