import Foundation

protocol StocksLoading {
    func loadTickers() async -> [Ticker]?
}

class StocksLoader: StocksLoading {
    func loadTickers() async -> [Ticker]? {
        guard
            let path = Bundle.main.path(forResource: "tickers", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let tickers = try? JSONDecoder().decode([Ticker].self, from: data)
        else { return nil }
        
        return tickers
    }
    
    func loadStocks() async -> [Stock]? {
        guard
            let path = Bundle.main.path(forResource: "stocks", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let stocks = try? JSONDecoder().decode([Stock].self, from: data)
        else { return nil }
        
        return stocks
    }
}

