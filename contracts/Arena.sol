pragma solidity ^0.6.0;

import "./Wizards.sol";

contract Arena is Wizards {
    
    function enterArena(uint256 tokenId) public {
        
    }
    
    function isTraitEffectiveAgainst(uint8 attacker, uint8 defender) public pure returns (bool) {
        return (((attacker + 1) % 4) == defender); // Thanks to Tourist
    }
    
    
    
}




