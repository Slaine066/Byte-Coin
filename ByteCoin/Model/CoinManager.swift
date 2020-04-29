import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, _ exchange: Double, _ currency: String)
    func updateCoinDidFail(_ coinManager: CoinManager, _ error: Error)
}

struct CoinManager {
    
    // Properties
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B9ACCDF7-A57A-43CF-973B-7799DA835143"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate? // Delegate Property
    
    
    func getCoinPrice(_ currency: String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(url, currency)
    }
    
    func performRequest(_ urlString: String, _ currency: String) {
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give URLSession a Task
            let task = session.dataTask(with: url) { (data, response, error) in // Since the last parameter of the methods dataTask is a function
                                                                                // we can use a trailing closure.
                if error != nil {
                    self.delegate?.updateCoinDidFail(self, error!)
                    return
                }
                
                if let safeData = data {
                    if let exchange = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, exchange, currency)
                    }
                }
            }
            
            // 4. Start the Task
            task.resume()
        }
    }
    
    // Function which parse from JSON format returning SwiftObject format (Coin Model)
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)

            let rate = decodedData.rate
            return rate
        } catch {
            delegate?.updateCoinDidFail(self, error)
            return nil
        }
    }
}
