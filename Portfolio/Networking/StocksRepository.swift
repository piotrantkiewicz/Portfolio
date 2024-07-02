import Foundation
import Alamofire

struct DataBasePOSTResponse: Codable {
    let name: String
}

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
    
    // Write functions for load bought tickers and load sold tickers here
    
    func addStock(_ ticker: Ticker) async throws -> String {
        guard let encodedSymbol = ticker.symbol.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid stock symbol"])
        }
        
        let url = URL(string: "\(baseURL)/stocks/\(encodedSymbol).json")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT" // Use PUT to ensure the ID is the ticker symbol
        request.httpBody = try JSONEncoder().encode(ticker)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(DataBasePOSTResponse.self, from: data)
        
        return decoded.name
    }
}
