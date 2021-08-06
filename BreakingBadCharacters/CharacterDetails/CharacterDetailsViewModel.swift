//
//  CharacterDetailsViewModel.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import Foundation
import Combine

class CharacterDetailsViewModel {
    
    let character: Character
    
    var coordinator: CharacterDetailsCoordinatorProtocol?
    
    var occupationString: String {
        character.occupation.joined(separator: ", ")
    }
    
    var appearanceString: String {
        character.appearance.map { String($0) }.joined(separator: ", ")
    }
    
    init(character: Character) {
        self.character = character
    }
    
    func onBackButtonPressed() {
        coordinator?.navigateBack()
    }
    
    
}
