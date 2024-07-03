import UIKit

class PortfolioViewController: UIViewController {
    
    @IBOutlet weak var portfolioLbl: UILabel!
    @IBOutlet weak var portfolioValueLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBackgroundView: UIView!
    @IBOutlet weak var addNewStockBtn: UIButton!
    
    var tickers: [Ticker] = []
    private let stocksRepository = StocksRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portfolioLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 14)
        portfolioValueLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 32)
        
        tableViewBackgroundView.clipsToBounds = true
        tableViewBackgroundView.layer.cornerRadius = 6
        tableViewBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addNewStockBtn.titleLabel?.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 14)
        addNewStockBtn.setCornerRadius(16)
        
        configureTableView()
        loadStocks()
    }
    
    private func configureTableView() {
        tableView.rowHeight = 156
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PortfolioStockCell", bundle: nil), forCellReuseIdentifier: "PortfolioStockCell")
    }
    
    private func loadStocks() {
        Task {
            if let loadedStocks = await stocksRepository.loadStocks() {
                self.tickers = loadedStocks.sorted(by: { $0.symbol < $1.symbol })
                tableView.reloadData()
            } else {
                print("Failed to load stocks from repository")
            }
        }
    }
    
    @IBAction func addNewStockBtnTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MarketViewController") as! MarketViewController
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
}

extension PortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioStockCell") as? PortfolioStockCell else {
            return UITableViewCell()
        }
        
        let ticker = tickers[indexPath.row]
        cell.configure(with: ticker)
        
        cell.selectionStyle = .none
        
        return cell
    }
}