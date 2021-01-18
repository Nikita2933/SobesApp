//
//  File.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//

import Foundation
// MARK: - Currency
struct Currency: Codable {
    let Valute: [String: Valute]

}

// MARK: - Valute
struct Valute: Codable {
    let ID, NumCode, CharCode: String
    let Nominal: Int
    let Name: String
    let Value, Previous: Double
}
