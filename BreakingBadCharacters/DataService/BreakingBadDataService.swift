//
//  CharacterListDataService.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import Foundation
import Combine

protocol BreakingBadServiceProtocol {
    func fetch() -> AnyPublisher<[Character], APIError>
}

enum APIError: Error {
    case unknown, apiError(reason: String), parserError(reason: String)
    
    var errorDescription: String {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason), .parserError(let reason):
            return reason
        }
    }
}

class BreakingBadDataService: BreakingBadServiceProtocol {
    
    let url: URL
    
    init(url: URL? = nil) {
        self.url = url ?? URL(string: "https://breakingbadapi.com/api/characters")!
    }
    
    func fetch() -> AnyPublisher<[Character], APIError> {
        return URLSession(configuration: .default).dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return data
            }
            .decode(type: [Character].self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case let error as APIError: return error
                case let error as DecodingError: return APIError.parserError(reason: error.localizedDescription)
                default: return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
