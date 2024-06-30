import Foundation

protocol StocksLoading {
    func load() async -> [Ticker]?
}

class StocksLoader: StocksLoading {
    func load() async -> [Ticker]? {
        guard
            let path = Bundle.main.path(forResource: "tickers", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let tickers = try? JSONDecoder().decode([Ticker].self, from: data)
        else { return nil }
        
        return tickers
    }
}

