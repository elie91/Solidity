pragma solidity ^0.4.19;

import "./ownable.sol";

contract ZombieFactory is Ownable {
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // stocke l'adresse associée à un zombie
    mapping(uint => address) public zombieToOwner;
    // stocke combien de zombies un utilisateur possède.
    mapping(address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
