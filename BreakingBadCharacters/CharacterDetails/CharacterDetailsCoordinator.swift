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
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
