import Foundation
import Alamofire

class StocksRepository: StocksLoading {
    
    private let url = "https://portfolio-4a6f3-default-rtdb.europe-west1.firebasedatabase.app/tickers.json"
    
    func load() async -> [Ticker]? {
        let response = await AF.request(url, interceptor: .retryPolicy)
            .serializingDecodable([Ticker?].self)
            .response
        
        return response.value?.compactMap {
            $0
        }
    }
}
