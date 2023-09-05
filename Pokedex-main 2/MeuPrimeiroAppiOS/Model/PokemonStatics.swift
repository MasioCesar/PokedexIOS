//
//  PokemonStatics.swift
//  MeuPrimeiroAppiOS
//
//  Created by user on 30/08/23.
//

import Foundation

struct Teste:Decodable{
    var flavor_text:String
}

struct PokemonDescription: Decodable {
    var flavor_text_entries:[Teste]
}

struct PokemonStatics: Decodable {
    var id: Int
    var weight: Int
    var height: Int
    /*var types: [type] = []
    var color: String {
        if self.types[0].name == "grass" {
            return "84CB72"
        }
        if self.types[0].name == "water" {
            return "84CB72"
        }
        if self.types[0].name == "fire" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        if self.types[0].name == "poison" {
            return "84CB72"
        }
        return ""
    }
    */
}
