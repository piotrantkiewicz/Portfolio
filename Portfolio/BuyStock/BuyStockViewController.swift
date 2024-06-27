import UIKit

class BuyStockViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var ticker: Ticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        titleLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 14)
        subtitleLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 12)
        subtitleLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 12)
    }
    
    private func configureView() {
        guard let ticker = ticker else { return }
        
        backgroundView.setCornerRadius(16)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor(hex: "#DFE1E7")?.cgColor
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 12
        
        titleLbl.text = ticker.symbol
        subtitleLbl.text = ticker.name
        logoImage.image = getImageForSymbol(ticker.symbol)
        confirmBtn.setCornerRadius(16)
        
        
        func getImageForSymbol(_ symbol: String) -> UIImage? {
            if let image = UIImage(named: symbol) {
                return image
            } else {
                return generateImageWithLetter(symbol.first)
            }
        }

        func generateImageWithLetter(_ firstLetter: Character?) -> UIImage? {
            guard let firstLetter = firstLetter else { return nil }

            let logo = UILabel()
            logo.frame.size = CGSize(width: 32, height: 32)
            logo.text = String(firstLetter)
            logo.textAlignment = .center
            logo.backgroundColor = UIColor(hex: "#F5F7F9")!
            logo.textColor = UIColor(hex: "#1A202C")!
            logo.font = UIFont(name: FontName.intertightBold.rawValue, size: 10)
            logo.setCornerRadius(20)

            UIGraphicsBeginImageContext(logo.frame.size)
            if let context = UIGraphicsGetCurrentContext() {
                logo.layer.render(in: context)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return image
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
    }
}
