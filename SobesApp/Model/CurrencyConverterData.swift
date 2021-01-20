//
//  File.swift
//  SobesApp
//
//  Created by Никита on 16.01.2021.
//


struct Currency: Codable {
    let Valute: [String: Valute]

}

struct Valute: Codable {
    let ID, NumCode, CharCode: String
    let Nominal: Int
    let Name: String
    let Value, Previous: Double
}
