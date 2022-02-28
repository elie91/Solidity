pragma solidity ^0.4.19;

// Lecon 1 : générer un zombie aléatoire, ce zombie est ajouté à la base de donnée de notre jeu stockée sur la blockchain.

contract ZombieFactory {
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16; // uint = entier non signé;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint256 _dna) private {
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint256) {
        // Convertir des données
        uint256 rand = uint256(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
