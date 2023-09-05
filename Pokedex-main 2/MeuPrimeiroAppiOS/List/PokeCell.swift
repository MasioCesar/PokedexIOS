import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var formattedHex = hex
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }

        var hexNumber: UInt64 = 0

        guard Scanner(string: formattedHex).scanHexInt64(&hexNumber) else {
            return nil
        }

        let red = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexNumber & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class MovieCell: UITableViewCell {
    
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 18
        return view
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()
    
    private let imageMoviewView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 18
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        return image
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalCentering
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let typeNamePrimary: UILabel = {
        let type = UILabel()
        type.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        type.numberOfLines = 0
     
        return type
    }()
    
    private func createAttributeIndicator() -> UIView {
        let indicatorView = UIView()
        indicatorView.layer.cornerRadius = 12

        return indicatorView
    }
    
    private let typeNameSecond: UILabel = {
        let type = UILabel()
        type.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        type.numberOfLines = 0
        return type
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContentView()
        addViewsInHierarchy()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(pokemon: PokemonData) {
        titleLabel.text = pokemon.name.capitalized
        idLabel.text = String(format: "#%03d", pokemon.id)
        typeNamePrimary.text = pokemon.types[0].name
        typeNamePrimary.backgroundColor = UIColor(hex: pokemon.types[0].color)
        typeNamePrimary.textAlignment = .center
        
        typeNameSecond.text = pokemon.types.count >= 2 ? pokemon.types[1].name : ""
        typeNameSecond.backgroundColor = UIColor(hex: pokemon.types.count >= 2 ? pokemon.types[1].color : "#acacb4")
        typeNameSecond.textAlignment = .center
        
        if let imageUrl = URL(string: pokemon.urlImg) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageMoviewView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

    }
    
    private func setupContentView() {
        selectionStyle = .none
    }
    
    private func addViewsInHierarchy() {
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(horizontalStack)
        
        // Adicione uma pilha para o ID e o nome
        let idNameStack = UIStackView()
        idNameStack.axis = .horizontal
        idNameStack.spacing = 8
        idNameStack.distribution = .fillProportionally

        idNameStack.addArrangedSubview(idLabel)
        idNameStack.addArrangedSubview(titleLabel)

        // Adicione a pilha de ID + Nome à pilha horizontal principal
        horizontalStack.addArrangedSubview(idNameStack)

        // Adicione uma pilha para os tipos do Pokémon
        let typesStack = UIStackView()
        typesStack.axis = .horizontal
        typesStack.spacing = 8
        typesStack.distribution = .fillProportionally

        typesStack.addArrangedSubview(typeNamePrimary)
        typesStack.addArrangedSubview(typeNameSecond)

        // Crie uma pilha vertical para empilhar o ID + Nome e os tipos do Pokémon
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.distribution = .fillProportionally
        
        // Adicione a pilha ID + Nome e a pilha de tipos à pilha vertical
        verticalStack.addArrangedSubview(idNameStack)
        verticalStack.addArrangedSubview(typesStack)

        // Adicione a pilha vertical à pilha horizontal principal
        horizontalStack.addArrangedSubview(verticalStack)

        // Adicione a imagem à direita
        horizontalStack.addArrangedSubview(imageMoviewView)
    }



    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 8),
            horizontalStack.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -8),
            horizontalStack.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            imageMoviewView.widthAnchor.constraint(equalToConstant: 100),
            imageMoviewView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
