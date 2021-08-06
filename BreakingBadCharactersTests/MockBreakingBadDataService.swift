//
//  MockBreakingBadDataService.swift
//  BreakingBadCharactersTests
//
//  Created by Felix Fischer on 06/08/2021.
//

import Foundation
import Combine

@testable import BreakingBadCharacters

class MockBreakingBadDataService: BreakingBadServiceProtocol {
    func fetch() -> AnyPublisher<[Character], APIError> {
        let urlToFile = Bundle(for: type(of: self)).url(forResource: "MockServiceJSON", withExtension: "json")!
        let data = try! Data(contentsOf: urlToFile)
        return Just<Data>(data)
            .decode(type: [Character].self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                switch error {
                case let error as DecodingError: return APIError.parserError(reason: error.localizedDescription)
                default: return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
        
    }
}
