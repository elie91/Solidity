# Solidity

## Contract

Un `contrat (contract)` permet d'encapsuler du code Solidity, c'est la composante fondamentale de toutes applications Ethereum - 
toutes les variables et fonctions appartiennent à un contrat, et ce sera le point de départ de tous vos projets.

## Pragma Version

Tout code source en Solidity doit commencer par un `pragma version` - une déclaration de la version du compilateur Solidity que ce code devra utiliser. Cela permet d'éviter d'éventuels problèmes liés aux changements introduits par des futures versions du compilateur.

Cela ressemble à ça : `pragma solidity ^0.4.19;` (la dernière version de Solidity au moment de la rédaction de cet article étant 0.4.19).

## Variables

Les variables d'état sont stockées de manière permanente dans le stockage du contrat.
Cela signifie qu'elles sont écrites dans la blockchain Ethereum.
C'est comme écrire dans une base de données.

Types de variables: 

* `uint` alias pour `uint256` => entier non signé, cela veut dire que sa valeur doit être non négative
* `int` => entiers signés
* `uint8`
* `uint16`
* `uint32`
* `string`
* `address`
...


## Stockage vs Mémoire

En Solidity, il y a deux endroits pour stocker les variables - dans le storage (stockage) ou dans la memory (mémoire).

Le stockage est utilisé pour les variables stockées de manière permanente dans la blockchain. Les variables mémoires sont temporaires, et effacées entre les appels de fonction extérieure à votre contrat. C'est un peu comme le disque dur et la mémoire vive de votre ordinateur.

La plupart du temps, vous n'aurez pas besoin d'utiliser ces mots clés car Solidity gère ça tout seul. les variables d'état (déclarées en dehors des fonctions) sont par défaut storage et écrites de manière permanente dans la blockchain, alors que les variables déclarées à l'intérieur des fonctions sont memory et disparaissent quand l'appel à la fonction est terminé.

Cependant, il peut arriver que vous ayez besoin d'utiliser ces mots clés, surtout quand vous utilisez des structures et des tableaux à l'intérieur de fonctions :

```solidity

  function eatSandwich(uint _index) public {
    // Sandwich mySandwich = sandwiches[_index];

    // ^ Cela pourrait paraître simple, mais Solidity renverra un avertissement
    // vous indiquant que vous devriez déclarer explicitement `storage` ou `memory` ici.

    // Vous devriez donc déclarez avec le mot clé `storage`, comme ceci :
    Sandwich storage mySandwich = sandwiches[_index];
    // ...dans ce cas, `mySandwich` est un pointeur vers `sandwiches[_index]`
    // dans le stockage et...
    mySandwich.status = "Eaten!";
    // ... changera définitivement `sandwiches[_index]` sur la blockchain.

    // Si vous voulez juste une copie, vous pouvez utiliser `memory`:
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
    // ...dans ce cas, `anotherSandwich` sera simplement une copie des
    // données dans la mémoire et...
    anotherSandwich.status = "Eaten!";
    // ... modifiera simplement la variable temporaire et n'aura pas
    // d'effet sur `sandwiches[_index + 1]`. Mais vous pouvez faire ceci :
    sandwiches[_index + 1] = anotherSandwich;
    // ...si vous voulez copier les modifications dans le stockage de la blockchain.
  }
}

```

## Structures de données

### Struct

Les `struct` vous permettent de créer des types de données plus complexes avec plusieurs propriétés.

```solidity
struct Person {
  uint age;
  string name;
}

Person satoshi = Person(172, "Satoshi");


```

### Tableaux

Quand vous voulez regrouper des éléments, vous pouvez utiliser un tableau (array). il y a deux sortes de tableaux dans Solidity : les tableaux `fixes` et les tableaux `dynamiques` :

```solidity
// Tableau avec une longueur fixe de 2 éléments :
uint[2] fixedArray;
// Un autre Tableau fixe, qui peut contenir 5 `string` :
string[5] stringArray;
// un Tableau dynamique, il n'a pas de taille fixe, il peut continuer de grandir :
uint[] dynamicArray;
```
Vous pouvez déclarer un tableau comme `public`, et Solidity créera automatiquement une méthode d'accès. La syntaxe ressemble à :

```
Person[] public people;
```

### Mapping
Un `mapping` est fondamentalement un stockage de clé-valeur pour stocker et rechercher des données. Dans le premier exemple, la clé est une address et la valeur est un uint, et dans le second exemple, la clé est un uint et la valeur un string.

````solidity
// Pour une application financière , stockage d'un `uint` qui correspond à la balance d'un compte utilisateur :
mapping (address => uint) public accountBalance;
// Ou peut être utilisé pour stocker puis rechercher le nom d'utilisateur en fonction d'un userId.
mapping (uint => string) userIdToName;
````

## Fonctions


### public

En Solidity, les fonctions sont publiques par défaut. Cela signifie que n'importe qui (ou n'importe quel contrat) peut appeler la fonction de votre contrat et exécuter son code.

### private

Évidemment, ce n'est pas toujours ce que l'on veut, cela pourrait rendre votre contrat vulnérable aux attaques. Il est donc recommandé de marquer vos fonctions comme `private` 
(privées) par défaut, puis de ne rendre `public` (publiques) seulement les fonctions que vous voulez exposer à tout le monde.

```solidity
function _addToArray(uint _number) private {
  numbers.push(_number);
}
```

### internal

`internal` est similaire à `private`, à l'exception qu'elle est aussi accessible aux contrats qui héritent de ce contrat.

### external

`external` est similaire à `public`, à l'exception que ces fonctions peuvent SEULEMENT être appelées à l'extérieur du contrat - elles ne peuvent pas être appelées par d'autres fonctions à l'intérieur du contrat. 


### Returns

Pour retourner une valeur à partir d'une fonction, cela ressemble à ça :

```solidity
string greeting = "What's up dog";

function sayHello() public returns (string) {
    return greeting;
}
```

Une fonction peut retourner plusieurs valeurs : 

```solidity
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // C'est comme ça que vous faites une affectation multiple :
  (a, b, c) = multipleReturns();
}

// Ou si nous voulons seulement une des valeurs ci dessus :
function getLastReturnValue() external {
  uint c;
  // Nous pouvons laisser les autres champs vides :
  (,,c) = multipleReturns();
}
```

### View

Une fonction qui ne modifie rien (qui ne change pas un état en Solidity) peut être déclaré avec `view`:

````solidity
function sayHello() public view returns (string)
````

### Pure

Une fonction qui ne modifie rien ET qui utilise uniquement ses propres arguments peut être déclarés comme `pure`:

````solidity
function _multiply(uint a, uint b) private pure returns (uint) {
  return a * b;
}
````

### require

`require` va faire en sorte que la fonction s’arrête et renvoie une erreur si certaines conditions ne sont pas respectées :

````solidity
function sayHiToVitalik(string _name) public returns (string) {
  // Regarde si _name est égal à "Vitalik". Renvoie une erreur et quitte si ce n'est pas le cas.
  // (Remarque : Solidity n'a pas de comparateur de `string` nativement,
  // nous comparons donc leurs hachages keccak256 pour voir si les `string` sont égaux)
  require(keccak256(_name) == keccak256("Vitalik"));
  // Si c'est vrai, on continue avec la fonction :
  return "Hi!";
}
````

## Evenements

Un  `évènement`est un moyen pour votre contrat d'indiquer à votre application frontale (front-end) 
que quelque chose vient d'arriver sur la blockchain, l'application frontale pouvant être 
«à l'écoute» de certains événements pour prendre des mesures quand ils se produisent.


````solidity
// déclaration de l'évènement
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public {
  uint result = _x + _y;
  // déclenchement de l'évènement pour indiquer à l'application que la fonction a été appelée :
  IntegersAdded(_x, _y, result);
  return result;
}
````

Sur le front : 

````javascript
YourContract.IntegersAdded(function(error, result) {
  // faire quelque chose avec le résultat
}
````

## Adresses

La blockchain Ethereum est constituée de `comptes`, un peu comme des comptes en banque. Un compte à un montant d'`Ether` (c'est la monnaie utilisée sur la blockchain Ethereum), et vous pouvez envoyer des Ethers à d'autres comptes ou en recevoir, de la même manière que vous pouvez transférer de l'argent d'un compte bancaire à un autre.

Chaque compte à une `address`, qui est l'équivalent d'un numéro de compte bancaire. c'est un identifiant unique qui désigne un compte et qui ressemble à :

0x0cE446255506E92DF41614C46F1d6df9Cc969183

Une adresse appartient à un `utilisateur unique (ou a un smart contract).`

## msg.sender

En Solidity, il existe des variables globales accessibles à toutes les fonctions. 
L'une d'elles est `msg.sender`, qui faire référence à l'`address` de la personne (ou du smart contract) qui a appelée la fonction actuelle.

Remarque : En Solidity, l'exécution d'une fonction nécessite obligatoirement un appel extérieur. Un contrat va juste rester là dans la blockchain à ne rien faire jusqu'à ce que quelqu'un appelle un de ses fonctions. Il y aura toujours un msg.sender.

Utiliser msg.sender apporte de la sécurité à la blockchain Ethereum - la seule manière pour quelqu'un de modifier les données d'un autre serait de lui voler sa clé privée associée à son adresse Ethereum.


## Héritage

````solidity
contract Doge {
  function catchphrase() public returns (string) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string) {
    return "Such Moon BabyDoge";
  }
}
````

## Interagir avec d'autres contrats

Pour que notre contrat puisse parler avec un autre contrat que nous ne possédons pas sur la blockchain, nous allons avoir besoin de définir une interface.

Prenons un exemple simple. Imaginons un contrat comme celui-ci sur la blockchain :

```solidity
contract LuckyNumber {
    mapping(address => uint) numbers;

    function setNum(uint _num) public {
        numbers[msg.sender] = _num;
    }

    function getNum(address _myAddress) public view returns (uint) {
        return numbers[_myAddress];
    }
}
```

Cela serait un simple contrat où n'importe qui pourrait stocker son nombre porte-bonheur, et il serait associé à leur adresse Ethereum. Ensuite n'importe qui pourrait regarder leur nombre porte-bonheur en utilisant leur adresse.

Maintenant, imaginons que nous avons un contrat externe qui voudrait lire les données de ce contrat en utilisant la fonction `getNum.`

Premièrement, nous devrions définir une `interface` du contract `LuckyNumber` :

````solidity
contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
````

Nous pouvons l'utiliser dans un contrat comme ceci :

````solidity
contract MyContract {
  address NumberInterfaceAddress = 0xab38...
  // ^ L'adresse du contrat FavoriteNumber sur Ethereum
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress)
  // Maintenant `numberContract` pointe vers l'autre contrat

  function someFunction() public {
    //Nous pouvons maintenant appeler `getNum` à partir de ce contrat :
    uint num = numberContract.getNum(msg.sender);
    // ...et faire quelque chose avec ce `num`
  }
}
````

De cette manière, votre contrat peut interagir avec n'importe quel autre contrat sur la blockchain Ethereum, tant qu'ils exposent leurs fonctions comme public ou external.










