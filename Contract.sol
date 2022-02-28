pragma solidity ^0.4.19;

// Lecon 1 : générer un zombie aléatoire, ce zombie est ajouté à la base de donnée de notre jeu stockée sur la blockchain.

contract ZombieFactory {
    // Les app front peuvent être à l'écoute d'événements
    // YourContract.NewZombie(function(error, result)
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    // Les variables d'état sont stockées de manière permanente dans le stockage du contrat.
    // Cela signifie qu'elles sont écrites dans la blockchain Ethereum.
    // C'est comme écrire dans une base de données.
    uint256 dnaDigits = 16; // uint = entier non signé;
    uint256 dnaModulus = 10**dnaDigits;

    // Les structures permettent de créer des types de données plus complexes avec plusieurs propriétés.
    struct Zombie {
        string name;
        uint256 dna;
    }

    // Tableaux: fixes ou dynamiques; on peut créer des tableaux de structure
    // Déclarer un tableau public = Méthode d'accès automatiquement créée
    Zombie[] public zombies;

    // fonctions sont publiques par défaut: n'importe quel contrat peut appeler la fonction
    // si une fonction modifie et retourne une valeur : function sayHello() public returns (string)
    // si une fonction ne modifie rien : function sayHello() public view returns (string)
    // si une fonction est pure: function _multiply(uint a, uint b) private pure returns (uint)
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
