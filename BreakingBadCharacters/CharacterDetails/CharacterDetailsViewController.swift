//
//  CharacterDetailsViewController.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import UIKit
import Combine
import SwiftUI
import Kingfisher

class CharacterDetailsViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    
    var viewModel: CharacterDetailsViewModel? {
        didSet {
            if let character = viewModel?.character, let imageUrl = URL(string: character.img) {
                imageView.kf.setImage(with: imageUrl)
                KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
                    if case let .success(imageResult) = result {
                        RemoveBackgroundService.removeBackground(of: imageResult.image) { image in
                            self.imageView.image = image
                        }
                    }
                }
            }
            nameLabel.text = viewModel?.character.name
        }
    }
    
    private lazy var backgroundImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "background2"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("back", for: .normal)
        button.publisher(for: .primaryActionTriggered).sink { _ in
            self.viewModel?.onBackButtonPressed()
        }.store(in: &cancellables)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: "Breaking B", size: 55) ?? UIFont.systemFont(ofSize: 55)
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.backgroundColor = UIColor(displayP3Red: 20/255, green: 47/255, blue: 9/255, alpha: 1)
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints  = false
        view.addSubview(nameLabel)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            view.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
            
            
        ])
        
        if let viewModel = viewModel {
            let characterDescriptionView = CharacterDetailsDescriptionView(viewModel: viewModel)
            let hc = UIHostingController(rootView: characterDescriptionView)
            view.addSubview(hc.view)
            hc.didMove(toParent: self)
            hc.view.translatesAutoresizingMaskIntoConstraints = false
            
            
            NSLayoutConstraint.activate([
                hc.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
                hc.view.topAnchor.constraint(equalTo: imageView.bottomAnchor),
                view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: hc.view.rightAnchor, constant: 16),
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: hc.view.bottomAnchor)
            ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension CharacterDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
