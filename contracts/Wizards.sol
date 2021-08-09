pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Wizards is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() public ERC721("Wizards", "WIZ") {}

    struct Wizard {
        uint256 wizardsIndexNumber;
        uint8 level;
        uint8 trait;
        uint8 weapon;
        bool inArena;
    }
    
    Wizard[] private wizards;
    uint256 private lastMintedBlock;
    uint256 private firstMintedOfLastBlock;
    
    modifier noFreshLookup(uint256 id) {
        _noFreshLookup(id);
        _;
    }

    function _noFreshLookup(uint256 id) internal view {
        require(id < firstMintedOfLastBlock || lastMintedBlock < block.number, "Too fresh for lookup");
    }

    function random() private view returns (uint8) {
      return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%4);
    }
    
    function spawnWizard(address player)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        
        uint256 wizardsIndexNumber = newItemId;
        uint8 level = 0;
        uint8 trait = uint8(random());
        uint8 weapon = uint8(random());
        bool inArena = false;

        wizards.push(Wizard(wizardsIndexNumber, level, trait, weapon, inArena));

        return newItemId;
    }
    
    function getLevel(uint256 id) public view noFreshLookup(id) returns (uint8) {
        return wizards[id].level; // this is used by dataminers and it benefits us
    }
    
    function getTrait(uint256 id) public view noFreshLookup(id) returns (uint8) {
        return wizards[id].trait;
    }
}
