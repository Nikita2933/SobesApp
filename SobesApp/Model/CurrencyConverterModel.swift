

//MARK: Currency Json Model

struct Currency: Codable {
    let Valute: [String: Valute]
    let Date: String
}

struct Valute: Codable {
    let ID, NumCode, CharCode: String
    let Nominal: Int
    let Name: String
    let Value, Previous: Double
}


