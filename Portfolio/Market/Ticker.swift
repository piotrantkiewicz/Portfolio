import UIKit

struct Ticker: Codable {
    let symbol: String
    let price: Double
    var totalPrice: Double?
    let name: String
    let type: String
    let change: [Change]?
    
    init(symbol: String, price: Double, totalPrice: Double, name: String, type: String, change: [Change]) {
        self.symbol = symbol
        self.price = price
        self.totalPrice = totalPrice
        self.name = name
        self.type = type
        self.change = change
    }
}

struct Change: Codable {
    let date: TimeInterval
    let close: Double
}
