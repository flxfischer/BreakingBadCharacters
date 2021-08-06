//
//  CharacterListItemCell.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import UIKit
import Kingfisher

class CharacterListItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CharacterListItemCell.self)
    
    var character: Character? {
        didSet {
            if let character = character, let imageUrl = URL(string: character.img) {
                imageView.kf.setImage(with: imageUrl)
            }
            titelLabel.text = character?.name
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var titelLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: "Breaking B", size: 30) ?? UIFont.systemFont(ofSize: 30)
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.backgroundColor = UIColor(displayP3Red: 20/255, green: 47/255, blue: 9/255, alpha: 1)
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(titelLabel)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titelLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            contentView.rightAnchor.constraint(equalTo: titelLabel.rightAnchor, constant: 16),
            titelLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
    
}
