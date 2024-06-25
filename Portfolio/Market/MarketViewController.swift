import UIKit

struct Ticker: Codable {
    let symbol: String
    let price: Double
    let name: String
    let type: String
    let change: [Change]
}

struct Change: Codable {
    let date: TimeInterval
    let close: Double
}

struct TickersJson: Codable {
    let tickers: [Ticker]
}

 
class MarketViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tickers: [Ticker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureCollectionView()
        loadTickers()
        
        titleLbl.font = UIFont(name: FontName.intertightBold.rawValue, size: 18)
        tableViewLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 18)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StockCell", bundle: nil), forCellReuseIdentifier: "StockCell")
        tableView.allowsSelection = false
    }
    
    private func configureCollectionView() {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "StockCardCell", bundle: nil), forCellWithReuseIdentifier: "StockCardCell")
        }
    
    private func loadTickers() {
        guard let path = Bundle.main.path(forResource: "market", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let tickersObject = try JSONDecoder().decode(TickersJson.self, from: data)
            self.tickers = tickersObject.tickers.filter { $0.type == "stock" }
        
            tableView.reloadData()
        } catch {
            print("Failed to load or parse JSON: \(error)")
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MarketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell") as? StockCell else { return UITableViewCell() }
        
        let ticker = tickers[indexPath.row]
        cell.configure(with: ticker)
        
        return cell
    }
}

extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StockCardCell", for: indexPath) as? StockCardCell else {
            return UICollectionViewCell()
        }
        
        let ticker = tickers[indexPath.item]
        cell.configure(with: ticker)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 239, height: 136)
    }
}
