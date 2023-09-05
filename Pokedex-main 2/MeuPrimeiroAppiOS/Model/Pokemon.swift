/*struct type: Decodable  {
    var name: String
}*/


struct NameType: Decodable {
    var name: String
}

struct TypePokemon: Decodable {
    var type: NameType
}

struct Pokemon: Decodable {
    let name: String
    let url: String
    var pokemonID: Int? {
        if let idString = url.split(separator: "/").last,
            let id = Int(idString) {
            return id
        }
        return nil
    }
    var urlImg: String {
            if let pokemonID = pokemonID {
                return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png"
            }
            return ""
        }
    
}

struct TypesPokemon: Decodable {
    var name: String
    var color: String
}

struct PokemonData: Decodable {
    var id: Int
    let name: String
    let url: String
    var pokemonID: Int? {
        if let idString = url.split(separator: "/").last,
            let id = Int(idString) {
            return id
        }
        return nil
    }
    var urlImg: String {
            if let pokemonID = pokemonID {
                return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png"
            }
            return ""
        }
    var weight: Int
    var height: Int
    var pokemonDescription: String
    var types: [TypesPokemon]
}

struct Flavor:Decodable{
    var flavor_text:String
}

struct PokemonDescription: Decodable {
    var flavor_text_entries:[Flavor]
}

struct PokemonStatics: Decodable {
    var id: Int
    var weight: Int
    var height: Int
    var types:[TypePokemon]
}
