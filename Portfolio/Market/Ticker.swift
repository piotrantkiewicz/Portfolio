import UIKit

struct Ticker: Codable {
    let symbol: String
    var price: Double
    let name: String
    let type: String
    let change: [Change]
    
    init(symbol: String, price: Double, name: String, type: String, change: [Change]) {
        self.symbol = symbol
        self.price = price
        self.name = name
        self.type = type
        self.change = change
    }
}

struct Change: Codable {
    let date: TimeInterval
    let close: Double
}
