//
//  Character.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

struct Character: Codable {
    let char_id: Int
    let name: String
    let occupation: [String]
    let img: String
    let status: String
    let nickname: String
    let appearance: [Int]
}
