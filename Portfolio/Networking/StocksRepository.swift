import Foundation
import Alamofire

class StocksRepository {
    
    private let baseURL = "https://portfolio-4a6f3-default-rtdb.europe-west1.firebasedatabase.app"
    
    func loadTickers() async -> [Ticker]? {
        let url = "\(baseURL)/tickers.json"
        let response = await AF.request(url, interceptor: .retryPolicy)
            .serializingDecodable([Ticker?].self)
            .response
        
        return response.value?.compactMap {
            $0
        }
    }
    
    func loadStocks() async -> [Ticker]? {
        let url = "\(baseURL)/stocks.json"
        let response = await AF.request(url, interceptor: .retryPolicy)
            .serializingString()
            .response
        
        guard let responseData = response.value else {
            print("Failed to get response data")
            return nil
        }

        if responseData == "null" || responseData.isEmpty {
            return []
        }

        let decoder = JSONDecoder()
        do {
            let tickerDict = try decoder.decode([String: Ticker].self, from: Data(responseData.utf8))
            let tickers = tickerDict.map { (key, value) in
                Ticker(symbol: key, price: value.price, totalPrice: value.totalPrice!, name: value.name, type: value.type, change: value.change!)
            }
            return tickers
        } catch {
            print("Failed to decode tickers: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addStock(_ ticker: Ticker) async throws -> String {
        guard let encodedSymbol = ticker.symbol.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid stock symbol"])
        }
        
        let url = URL(string: "\(baseURL)/stocks/\(encodedSymbol).json")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(ticker)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(Ticker.self, from: data)
        
        return decoded.name
    }
    
    func updateStock(_ ticker: Ticker) async throws {
        guard let encodedSymbol = ticker.symbol.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid stock symbol"])
        }
        
        let url = URL(string: "\(baseURL)/stocks/\(encodedSymbol).json")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = try JSONEncoder().encode(ticker)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
        }
        
        let responseData = String(data: data, encoding: .utf8) ?? "No response data"
        print("Response data: \(responseData)")
        
        let decoded = try JSONDecoder().decode(Ticker.self, from: data)
        
        print("Updated stock: \(decoded)")
    }
    
    func deleteStock(_ ticker: Ticker) async throws {
        guard let encodedSymbol = ticker.symbol.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid stock symbol"])
        }
        
        let url = URL(string: "\(baseURL)/stocks/\(encodedSymbol).json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
    }
}
