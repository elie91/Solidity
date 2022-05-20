/**
 * @title Ownable
  * @dev Le contrat Ownable a une adresse de propriétaire, et offre des fonctions de contrôle
  * d’autorisations basiques, pour simplifier l’implémentation des "permissions utilisateur".
  */
contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Le constructeur Ownable défini le `owner` (propriétaire) original du contrat égal
    * à l'adresse du compte expéditeur (msg.sender).
    */
    function Ownable() public {
        owner = msg.sender;
    }

    /**
     * @dev Abandonne si appelé par un compte autre que le `owner`.
   */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Permet au propriétaire actuel de transférer le contrôle du contrat
    * à un `newOwner` (nouveau propriétaire).
    * @param newOwner C'est l'adresse du nouveau propriétaire
    */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
