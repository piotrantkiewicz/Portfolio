import UIKit

class PortfolioStockCell: UITableViewCell {
    
    @IBOutlet weak var stockCellBackgroundView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var portfolioLbl: UILabel!
    @IBOutlet weak var portfolioValueLbl: UILabel!
    @IBOutlet weak var stockLbl: UILabel!
    @IBOutlet weak var stockValueLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.font = UIFont(name: FontName.intertightBold.rawValue, size: 14)
        subtitleLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 10)
        portfolioLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 12)
        portfolioValueLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 18)
        stockLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 12)
        stockValueLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 18)
    }
    
    func configure(with ticker: Ticker) {
        titleLbl.text = ticker.symbol
        subtitleLbl.text = ticker.name
        stockValueLbl.text = String(format: "%.2f", ticker.price)
        
        stockCellBackgroundView.clipsToBounds = true
        stockCellBackgroundView.setCornerRadius(16)
        
        logoImage.image = getImageForSymbol(ticker.symbol)
    }
    
    private func getImageForSymbol(_ symbol: String) -> UIImage? {
        if let image = UIImage(named: symbol) {
            return image
        } else {
            return generateImageWithLetter(symbol.first)
        }
    }

    private func generateImageWithLetter(_ firstLetter: Character?) -> UIImage? {
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
