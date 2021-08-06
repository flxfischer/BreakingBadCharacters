//
//  CharacterDetailsCoordinator.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import UIKit

protocol CharacterDetailsCoordinatorProtocol {
    func navigateBack()
}

class CharacterDetailsCoordinator: CharacterDetailsCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let transitioningCoordinator = TransitioningCoordinator()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateBack() {
        navigationController.delegate = transitioningCoordinator
        navigationController.popViewController(animated: true)
    }
}
