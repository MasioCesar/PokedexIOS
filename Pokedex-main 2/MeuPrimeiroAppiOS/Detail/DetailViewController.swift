import UIKit

class DetailViewController: UIViewController {
    
   
    @IBOutlet weak var idPoke: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var typeViewPrimary: UIView!
    @IBOutlet weak var typeViewSecond: UIView!
    @IBOutlet weak var typeLabelPrimary: UILabel!
    @IBOutlet weak var typeLabelSecond: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var descriptionPoke: UITextView!
    
    var pokemonData: PokemonData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            movieImageView.layer.cornerRadius = 50
            movieImageView.layer.masksToBounds = true
            movieImageView.contentMode = .scaleAspectFill
            movieImageView.backgroundColor = .gray

            configure(with: pokemonData)
        }
        
    func configure(with pokemon: PokemonData) {
        idPoke.text = String(format: "#%03d", pokemon.id)
        movieTitle.text = pokemon.name.capitalized
        descriptionPoke.text = pokemon.pokemonDescription
        weight.text = String(format: "%.1f kg", Float(pokemon.weight) / 10.0)
        height.text = String(format: "%.1f m", Float(pokemon.height) / 10.0)
            
            if let imageUrl = URL(string: pokemon.urlImg) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.movieImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        typeViewPrimary.backgroundColor = UIColor(hex: pokemon.types[0].color)
        typeLabelPrimary.text = pokemon.types[0].name
        typeLabelPrimary.textAlignment = .center
        
        typeViewSecond.backgroundColor = UIColor(hex: pokemon.types.count >= 2 ? pokemon.types[1].color : "#ffffff")
        typeLabelSecond.text = pokemon.types.count >= 2 ? pokemon.types[1].name : ""
        typeLabelSecond.textAlignment = .center
        }
}
