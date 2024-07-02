# Desafio_PokeDIO_01

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; 

// Declaração do contrato PokeDIO que herda de ERC721
contract PokeDIO is ERC721 {

    // Estrutura que representa um Pokémon
    struct Pokemon {
        string name;  // Nome do Pokémon
        uint level;   // Nível do Pokémon
        string img;   // URL da imagem do Pokémon
    }

    // Array público que armazena todos os Pokémons
    Pokemon[] public pokemons;

    // Endereço do dono do jogo
    address public gameOwner;

    // Construtor do contrato que inicializa o ERC721 com o nome e símbolo
    constructor () ERC721 ("PokeDIO", "PKD") {   
        gameOwner = msg.sender;  // Define o dono do jogo como o criador do contrato
    }

    // Modificador que permite a execução apenas pelo dono de um Pokémon específico
    modifier onlyOwnerOf(uint _monsterId) {
        require(ownerOf(_monsterId) == msg.sender, "Apenas o dono pode batalhar com este Pokemon");
        _;
    }

    // Função para batalhar entre dois Pokémons
    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon) {
        Pokemon storage attacker = pokemons[_attackingPokemon];  // Referência ao Pokémon atacante
        Pokemon storage defender = pokemons[_defendingPokemon];  // Referência ao Pokémon defensor

        // Lógica da batalha: se o nível do atacante for maior ou igual ao do defensor
        if (attacker.level >= defender.level) {
            attacker.level += 2;  // Aumenta o nível do atacante em 2
            defender.level += 1;  // Aumenta o nível do defensor em 1
        } else {
            attacker.level += 1;  // Aumenta o nível do atacante em 1
            defender.level += 2;  // Aumenta o nível do defensor em 2
        }
    }

    // Função para criar um novo Pokémon
    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons");  // Verifica se quem chama a função é o dono do jogo
        uint id = pokemons.length;  // ID do novo Pokémon é o tamanho do array
        pokemons.push(Pokemon(_name, 1, _img));  // Adiciona um novo Pokémon com nível 1 ao array
        _safeMint(_to, id);  // Mint seguro do novo Pokémon para o endereço especificado
    }
}
