import UIKit

class SellStockViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var textBoxTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldDollarSighLbl: UILabel!
    @IBOutlet weak var stockValueLbl: UILabel!
    @IBOutlet weak var sellAllSharesBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var confirmBtnBottomConstraint: NSLayoutConstraint!
    
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
        
        guard let totalPrice = ticker?.totalPrice else { return }
        
        let title = "Sell all shares (\(totalPrice))"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.intertightSemiBold.rawValue, size: 14)!
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        sellAllSharesBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        stockValueLbl.text = String(format: "%.2f", ticker.totalPrice ?? 0.0)
        confirmBtn.setCornerRadius(16)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textFieldDollarSighLbl.alpha = textField.text?.isEmpty == false ? 1 : 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let amountToSubtract = Double(text) else {
            textField.text = String(format: "%.2f", ticker?.totalPrice ?? 0.0)
            return
        }

        if var ticker = ticker {
            ticker.totalPrice = (ticker.totalPrice ?? 0.0) - amountToSubtract
            self.ticker = ticker
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard var ticker = ticker else { return }
        
        if let text = textField.text, let amountToSubtract = Double(text) {
            ticker.totalPrice = (ticker.totalPrice ?? 0.0) - amountToSubtract
        }
        
        Task {
            do {
                if (ticker.totalPrice ?? 0.0) <= 0 {
                    try await stocksRepository.deleteStock(ticker)
                } else {
                    try await stocksRepository.updateStock(ticker)
                }
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .stockSold, object: nil)
                    self.dismiss(animated: true)
                }
            } catch {
                print("Failed to update stock: \(error)")
            }
        }
    }
    
    @IBAction func sellAllSharesBtnTapped(_ sender: Any) {
        guard var ticker = ticker else { return }
        Task {
            try await stocksRepository.deleteStock(ticker)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .stockSold, object: nil)
                self.dismiss(animated: true)
            }
        }
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            textBoxTopConstraint.constant = 60
            confirmBtnBottomConstraint.constant = keyboardFrame.height + 10
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        textBoxTopConstraint.constant = 120
        confirmBtnBottomConstraint.constant = 10
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension Notification.Name {
    static let stockSold = Notification.Name("stockSold")
}
