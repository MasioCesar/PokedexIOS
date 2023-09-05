//
//  PokemonSelected.swift
//  MeuPrimeiroAppiOS
//
//  Created by user on 30/08/23.
//

import Foundation

struct PokemonSelected: Codable {
    var sprites: PokemonSprites
    var weight: Int
    var height: Int
    var type: String
    
}
struct PokemonSprites: Codable {
    var front_defaults: String
}
class PokemonSelectedAPI {
    func getData(url: String, completion: @escaping (PokemonSprites) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let pokemonSprite = try! JSONDecoder().decode(PokemonSelected.self, from: data)
            DispatchQueue.main.async {
                completion(pokemonSprite.sprites)
            }
        }.resume()
    }
}
