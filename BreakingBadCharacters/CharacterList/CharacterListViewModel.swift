//
//  CharacterListViewModel.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import Foundation
import Combine
import UIKit

class CharacterListViewModel {
    
    enum State {
        case loading, loaded(characters: [Character]), error(reason: String)
    }
    
    private let service: BreakingBadServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    var coordinator: CharacterListCoordinatorProtocol?
    
    private var allCharacters: [Character] = []
    @Published var state: State = .loading
    @Published var filterButtonTitle: String = "All Seasons"
    
    init(service: BreakingBadServiceProtocol) {
        self.service = service
    }
    
    func loadData() {
        state = .loading
        service.fetch()
            .receive(on: DispatchQueue.main)
            .sink { result in
                if case let .failure(error) = result {
                    self.state = .error(reason: error.errorDescription)
                }
            } receiveValue: { characters in
                self.allCharacters = characters
                self.state = .loaded(characters: characters)
            }
            .store(in: &cancellables)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        if case let .loaded(characters: characters) = state {
            coordinator?.showDetail(with: characters[indexPath.item])
        }
    }
    
    func filterResults(for keyword: String?) {
        guard let keyword = keyword, !keyword.isEmpty else {
            state = .loaded(characters: allCharacters)
            return
        }
        let filteredCharacters = allCharacters.filter {
            $0.name.contains(keyword)
        }
        state = .loaded(characters: filteredCharacters)
    }
    
    func filterResults(by season: Int?) {
        guard let season = season else {
            filterButtonTitle = "All Seasons"
            state = .loaded(characters: allCharacters)
            return
        }
        let filteredCharacters = allCharacters.filter {
            $0.appearance.contains(season)
        }
        filterButtonTitle = "Season \(season)"
        state = .loaded(characters: filteredCharacters)
    }
}
