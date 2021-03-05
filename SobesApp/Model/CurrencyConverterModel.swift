

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

func valuteArrConvert(sort: Currency) -> [Valute] {
    var valute: [Valute] = []
    let keys = sort.Valute.keys.sorted()
    for key in keys {
        if let val = sort.Valute[key] {
            valute.append(val)
        }
        
    }
    return valute
}
