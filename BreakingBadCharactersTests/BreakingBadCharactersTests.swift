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
}
