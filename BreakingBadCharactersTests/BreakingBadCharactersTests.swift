//
//  BreakingBadCharactersTests.swift
//  BreakingBadCharactersTests
//
//  Created by Felix Fischer on 06/08/2021.
//

import XCTest
import Combine
@testable import BreakingBadCharacters

class BreakingBadCharactersTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func testBreakingBadDataService() {
        let service = BreakingBadDataService()
        let expectation = expectation(description: "Wait for service")
        var characters: [Character] = []
        service.fetch().sink { result in
            
        } receiveValue: { charactersResult in
            characters = charactersResult
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(characters.count, 62)

    }
    
    func testSeasonsFilter() {
        let service = MockBreakingBadDataService()
        let expectation = expectation(description: "Wait for filter")
        var characters: [Character] = []
        var calls = 0
        let viewModel = CharacterListViewModel(service: service)
        
        viewModel.$state.sink { state in
            if case let .loaded(characters: charactersResult) = state {
                if calls < 1 {
                    calls += 1
                    viewModel.filterResults(by: 2)
                } else {
                    characters = charactersResult
                    expectation.fulfill()
                }
            }
        }.store(in: &cancellables)
        
        viewModel.loadData()
        
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(characters.count, 36)
    }
    
    func testNameSearchFilter() {
        let service = MockBreakingBadDataService()
        let expectation = expectation(description: "Wait for filter")
        var characters: [Character] = []
        var calls = 0
        let viewModel = CharacterListViewModel(service: service)
        
        viewModel.$state.sink { state in
            if case let .loaded(characters: charactersResult) = state {
                if calls < 1 {
                    calls += 1
                    viewModel.filterResults(for: "Wal")
                } else {
                    characters = charactersResult
                    expectation.fulfill()
                }
            }
        }.store(in: &cancellables)
        
        viewModel.loadData()
        
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(characters.count, 2)
    }
}
