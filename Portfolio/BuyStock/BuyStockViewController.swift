import UIKit

class BuyStockViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var textBoxTopContstraint: NSLayoutConstraint!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldDollarSighLbl: UILabel!
    @IBOutlet weak var stockValueLbl: UILabel!
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
        stockValueLbl.text = String(format: "%.2f", ticker.price)
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
        
        ticker?.totalPrice = price
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard var ticker = ticker else { return }
        
        if let text = textField.text, let price = Double(text) {
            ticker.totalPrice = price
        }
        
        let prompt = UIAlertController(
            title: "Please confirm purchase",
            message: "You’re buying \(ticker.symbol) at $\(ticker.price) per share for the amount of $\(ticker.totalPrice!)",
            preferredStyle: .alert
        )
        
        prompt.addAction(UIAlertAction(
            title: "Confirm",
            style: .default,
            handler: { [weak self] _ in
                Task {
                    do {
                        try await self?.stocksRepository.addStock(ticker)
                        NotificationCenter.default.post(name: .stockAdded, object: nil)
                    
                        DispatchQueue.main.async {
                            self?.dismiss(animated: true)
                        }
                    } catch {
                        print("Failed to add stock: \(error)")
                    }
                }
            }
        ))
        
        prompt.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.present(prompt, animated: true)
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            textBoxTopContstraint.constant = 60
            confirmBtnBottomConstraint.constant = keyboardFrame.height + 10
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        textBoxTopContstraint.constant = 120
        confirmBtnBottomConstraint.constant = 10
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension Notification.Name {
    static let stockAdded = Notification.Name("stockAdded")
}
