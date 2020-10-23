//
//  Pokemon.swift
//  Pokedex
//
//  Created by Hlyan Htet on 22/10/2020.
//

import Foundation

struct PokemonList : Codable {
    let results : [Pokemon]
}

struct Pokemon : Codable {
    let name: String
    let url: String
}

struct PokemonData : Codable {
    let id : Int
    let sprites: PokemonImage
    let types : [PokemonTypeEntry]
}

struct PokemonImage : Codable {
    let front_default : String
    let back_default : String
}

struct PokemonTypeEntry : Codable {
    let slot : Int
    let type : PokemonType
}

struct PokemonType : Codable {
    let name : String
    let url : String
}
