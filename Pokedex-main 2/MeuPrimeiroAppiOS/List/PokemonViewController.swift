import UIKit

class PokemonViewController: UIViewController {
    private var movies: [PokemonData] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Pokédex"
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        addViewsInHierarchy()
        setupConstraints()
        fetchRemotePokemons()
    }
    
    private func addViewsInHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func fetchRemotePokemons() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=40")!
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching Pokémon list: \(error)")
                return
            }
            
            guard let pokemonsData = data else {
                print("No data received for Pokémon list")
                return
            }
            
            do {
                let pokemonListResponse = try JSONDecoder().decode(PokemonListResponse.self, from: pokemonsData)
                
                let group = DispatchGroup()
                var fetchedPokemons: [PokemonData] = []
                
                for remotePokemon in pokemonListResponse.results {
                    group.enter()
                    
                    self.fetchPokemonDetails(url: remotePokemon.url, namePokemon: remotePokemon.name) { pokemonData in
                        if let pokemonData = pokemonData {
                            fetchedPokemons.append(pokemonData)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    DispatchQueue.main.async {
                        fetchedPokemons.sort { $0.id < $1.id }
                        self.movies = fetchedPokemons
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error decoding PokemonListResponse: \(error)")
            }
        }
        
        task.resume()
    }

    private func fetchPokemonDetails(url: String, namePokemon: String,  completion: @escaping (PokemonData?) -> Void) {
        guard let pokemonURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        let pokemonRequest = URLRequest(url: pokemonURL)
        
        URLSession.shared.dataTask(with: pokemonRequest) { data, _, error in
            if let error = error {
                print("Error fetching Pokémon details: \(error)")
                completion(nil)
                return
            }
            
            guard let pokemonData = data else {
                print("No data received for Pokémon details")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            
            if let pokemonDetails = try? decoder.decode(PokemonStatics.self, from: pokemonData) {
                self.fetchPokemonDescription(id: pokemonDetails.id) { description in
                    if let description = description {
                        let typesPokemon = pokemonDetails.types.map { type in
                            if type.type.name == "grass" {
                                return TypesPokemon(name: "grass", color: "#84CB72")
                            }
                            if type.type.name == "water" {
                                return TypesPokemon(name: "water", color: "#4E8BD1")
                                   }
                            if type.type.name == "fire" {
                                return TypesPokemon(name: "fire", color: "#EB7E4F")
                                   }
                            if type.type.name == "poison" {
                                return TypesPokemon(name: "poison", color: "#C354EA")
                                   }
                            if type.type.name == "flying" {
                                return TypesPokemon(name: "flying", color: "#BEBEBE")
                                   }
                            if type.type.name == "fighting" {
                                return TypesPokemon(name: "fighting", color: "#CE416B")
                                   }
                            if type.type.name == "normal" {
                                return TypesPokemon(name: "normal", color: "#919AA2")
                                   }
                            if type.type.name == "electric" {
                                return TypesPokemon(name: "electric", color: "#F4D23C")
                                   }
                            if type.type.name == "ground" {
                                return TypesPokemon(name: "ground", color: "#D97845")
                                   }
                            if type.type.name == "rock" {
                                return TypesPokemon(name: "rock", color: "#C5B78C")
                                   }
                            if type.type.name == "psychic" {
                                return TypesPokemon(name: "psychic", color: "#FA7179")
                                   }
                            if type.type.name == "ice" {
                                return TypesPokemon(name: "ice", color: "#73CEC0")
                                   }
                            if type.type.name == "bug" {
                                return TypesPokemon(name: "bug", color: "#91C12F")
                                   }
                            if type.type.name == "ghost" {
                                return TypesPokemon(name: "ghost", color: "#5269AD")
                                   }
                            if type.type.name == "steel" {
                                return TypesPokemon(name: "steel", color: "#5A8EA2")
                                   }
                            if type.type.name == "dragon" {
                                return TypesPokemon(name: "dragon", color: "#0B6DC3")
                                   }
                            if type.type.name == "fairy" {
                                return TypesPokemon(name: "fairy", color: "#EC8FE6")
                                   }
                            
                            else {
                                return nil // Retorno padrão para outros tipos
                            }
                        }.compactMap { $0 }
                        
                        let newPokemon = PokemonData(
                            id: pokemonDetails.id,
                            name: namePokemon,
                            url: url,
                            weight: pokemonDetails.weight,
                            height: pokemonDetails.height,
                            pokemonDescription: description,
                            types: typesPokemon
                        )
                        
                        completion(newPokemon)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    private func fetchPokemonDescription(id: Int, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching Pokémon description: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received for Pokémon description")
                completion(nil)
                return
            }
            
            if let description = try? JSONDecoder().decode(PokemonDescription.self, from: data) {
                completion(description.flavor_text_entries[1].flavor_text.replacingOccurrences(of: "\n", with: " "))
            } else {
                completion(nil)
            }
        }.resume()
    }

}

extension PokemonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = MovieCell()
            let movie = movies[indexPath.row]
            print(movie)
            cell.configure(pokemon: movie)
            return cell
        }



    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        detailViewController.pokemonData = movies[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
