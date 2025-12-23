// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { XifraICO3 } from "./XifraICO3.sol";
import {Proxy} from "./Proxy.sol";
//import {ERC1967Utils} from "./ERC1967Utils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./token/IERC20.sol";
import {StorageSlot} from "./utils/StorageSlot.sol";
contract XifraProxy is Proxy, Initializable {
    address immutable private xifraWallet = msg.sender;
    address private owner = msg.sender; 
    address immutable private usdtToken;                        // USDT token address
    address immutable private usdcToken;                       // USDC token address        
    uint256 public value;
    uint256 immutable private icoStartDate;                     // ICO start date
    uint256 immutable private icoEndDate;                       // ICO end date
    address public implementation;
    bool private icoFinished;

    modifier onlyOwner() {
        // Revert the transaction if the caller is not the owner
        require(msg.sender == owner, "Only owner can call this function");
        // The '_' symbol tells Solidity to execute the function body here
        _;
    }
    //event Received(uint value);
    event onWithdrawICOFunds(uint256 _usdtBalance, uint256 _usdcBalance, uint256 _ethbalance);
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    error ERC1967InvalidImplementation(address implementation);

   fallback() external payable override {
    //uint256 _usdtBalance;
    //uint256 _usdcBalance;
    //uint256 _ethbalance;
    
 (bool success, ) = implementation.delegatecall(abi.encodeWithSelector(
    bytes4(keccak256("withdrawICOFunds()")),
    msg.value));

  // emit XifraICO3.onWithdrawICOFunds(_usdtBalance, _usdcBalance, _ethbalance);
    require(success, "Delegation failed");

	 /*    address addr = implementation; // Gets the address of the implementation contract
    assembly {
        // Copy the incoming calldata into memory
        calldatacopy(0, 0, calldatasize())
        // Delegatecall to the implementation contract
        let result := delegatecall(gas(), addr, 0, calldatasize(), 0, 0)
        // Copy the returndata from the implementation call
        returndatacopy(0, 0, returndatasize())
        // Revert or return based on the call's success
        switch result
        case 0 { revert(0, returndatasize()) }
        default { return(0, returndatasize()) }
    }/*
    }
   
      receive() external payable override {
 
   }

    function setImplementation (address _implementation) public onlyOwner {
    implementation = _implementation;
    }
    
    function _setImplementation(address newImplementation) private {
        if (newImplementation.code.length == 0) {
            revert ERC1967InvalidImplementation(newImplementation);
        }
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = newImplementation;
    }

    
    /**
     * @dev Returns the current implementation address.
     *
     * TIP: To get this value clients can read directly from the storage slot shown below (specified by ERC-1967) using
     * the https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
     * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
     */
    function _implementation() internal view virtual override returns (address) {
        return implementation;
    }
 
     function initialize(address initialOwner) public onlyOwner initializer {
        owner = initialOwner;
        //value = initialValue;
    }

    function withdrawReceive() external payable onlyOwner {
     // Get the total balance of the contract
        uint256 ethbalance = address(this).balance;

        // Transfer the balance to the owner
        // Using call is generally recommended for robustness
        (bool success, ) = payable(msg.sender).call{value: ethbalance}("");
        require(success, "Withdrawal failed");
   }

   function getBalance() public view returns (uint256) {
        return address(this).balance;}

// icoAddress 0x8C84dc4c71F959F84104156E2c8c293daAB18d39
//funcsign 0x2bf57fca
 function withdrawICOFunds() external payable {
        require(_isICOActive() == false, "ICOStillActive");
        
        uint256 usdtBalance = IERC20(usdtToken).balanceOf(address(this));
        require(IERC20(usdtToken).transfer(xifraWallet, usdtBalance));

        uint256 usdcBalance = IERC20(usdcToken).balanceOf(address(this));
        require(IERC20(usdcToken).transfer(xifraWallet, usdcBalance));

        uint256 ethbalance = address(this).balance;
        payable(xifraWallet).transfer(ethbalance);

        emit onWithdrawICOFunds(usdtBalance, usdcBalance, ethbalance);
    }
        function _isICOActive() internal view returns(bool) {
        if ((block.timestamp < icoStartDate) || (block.timestamp > icoEndDate) || (icoFinished == true)) return false;
        else return true;
    }
   }
/*
   contract XifraProxy2  {
      
        modifier onlyOwner() {
        // Revert the transaction if the caller is not the owner
        require(msg.sender == owner, "Only owner can call this function");
        // The '_' symbol tells Solidity to execute the function body here
        _;
    }
    constructor() {

    }  
   function withdrawReceive() external payable onlyOwner {
     // Get the total balance of the contract
        uint256 ethbalance = address(this).balance;

        // Transfer the balance to the owner
        // Using call is generally recommended for robustness
        (bool success, ) = payable(msg.sender).call{value: ethbalance}("");
        require(success, "Withdrawal failed");
   }

   function getBalance() public view returns (uint256) {
        return address(this).balance;}
    }*/

