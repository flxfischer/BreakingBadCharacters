//
//  CharacterListCoordinator.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import UIKit

protocol CharacterListCoordinatorProtocol {
    func showDetail(with character: Character)
}

class CharacterListCoordinator: CharacterListCoordinatorProtocol {
    let navigationController: UINavigationController
    
    private let transitioningCoordinator = TransitioningCoordinator()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetail(with character: Character) {
        let viewModel = CharacterDetailsViewModel(character: character)
        let coordinator = CharacterDetailsCoordinator(navigationController: navigationController)
        viewModel.coordinator = coordinator
        let vc = CharacterDetailsViewController()
        vc.viewModel = viewModel
        
        navigationController.delegate = transitioningCoordinator
        navigationController.interactivePopGestureRecognizer?.delegate = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
}
