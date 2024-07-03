import UIKit

class BuyStockViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldDollarSighLbl: UILabel!
    @IBOutlet weak var stockValueLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var ticker: Ticker?
    
    private let stocksRepository = StocksRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        titleLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 14)
        subtitleLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 12)
        stockValueLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 14)
        headlineLbl.font = UIFont(name: FontName.intertightBold.rawValue, size: 16)
        subtitleLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 12)
        textField.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 48)
        textFieldDollarSighLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 20)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        
        textField.keyboardType = .decimalPad
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func configure() {
        guard let ticker = ticker else { return }
        
        backgroundView.setCornerRadius(16)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor(hex: "#DFE1E7")?.cgColor
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 12
        
        titleLbl.text = ticker.symbol
        subtitleLbl.text = ticker.name
        logoImage.image = ImageUtility.getImageForSymbol(ticker.symbol)
        stockValueLbl.text = String(format: "%.2f", ticker.price)
        textField.text = String(format: "%.2f", ticker.price)
        confirmBtn.setCornerRadius(16)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textFieldDollarSighLbl.alpha = textField.text?.isEmpty == false ? 1 : 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let price = Double(text) else {
            textField.text = String(format: "%.2f", ticker?.price ?? 0.0)
            return
        }
        
        ticker?.price = price
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard var ticker = ticker else { return }
        
        if let text = textField.text, let price = Double(text) {
            ticker.price = price
        }
        
        Task {
            try await stocksRepository.addStock(ticker)
            NotificationCenter.default.post(name: .stockAdded, object: nil)
            
            let portfolioVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "PortfolioViewController") as! PortfolioViewController
            portfolioVC.modalPresentationStyle = .fullScreen
            
            present(portfolioVC, animated: true)
        }
    }
}

extension Notification.Name {
    static let stockAdded = Notification.Name("stockAdded")
}
