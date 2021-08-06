//
//  CharacterListDataSource.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import Foundation
import UIKit

class CharacterListDataSource: NSObject, UICollectionViewDataSource {
    
    var characters: [Character] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterListItemCell.reuseIdentifier, for: indexPath) as? CharacterListItemCell else { fatalError() }
        cell.character = characters[indexPath.item]
        return cell
    }
    
    
}
