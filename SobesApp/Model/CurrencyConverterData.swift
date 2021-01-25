

//MARK: Currency Json Model

struct Currency: Codable {
    let Valute: [String: Valute]

}

struct Valute: Codable {
    let ID, NumCode, CharCode: String
    let Nominal: Int
    let Name: String
    let Value, Previous: Double
}
