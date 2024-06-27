import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var stockValueLbl: UILabel!
    @IBOutlet weak var stockChangeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.font = UIFont(name: FontName.intertightBold.rawValue, size: 14)
        subtitleLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 10)
        stockValueLbl.font = UIFont(name: FontName.intertightBold.rawValue, size: 14)
        stockChangeLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 12)
    }
    
    func configure(with ticker: Ticker) {
        titleLbl.text = ticker.symbol
        subtitleLbl.text = ticker.name
        stockValueLbl.text = String(format: "%.2f", ticker.price)
        
        if let firstChange = ticker.change.first, let lastChange = ticker.change.last {
            let changeValue = lastChange.close - firstChange.close
            stockChangeLbl.text = String(format: "%.2f", changeValue)
            
            lineChart.lineColor = changeValue < 0 ? UIColor(hex: "#E20029")! : UIColor(hex: "#16A34A")!
            lineChart.shadowColor = changeValue < 0 ? UIColor(hex: "#E20029")!.withAlphaComponent(0.2) : UIColor(hex: "#16A34A")!.withAlphaComponent(0.2)
            stockChangeLbl.textColor = changeValue < 0 ? UIColor(hex: "#E20029")! : UIColor(hex: "#16A34A")!
        }
        
        let chartData = ticker.change.map { $0.close }
        lineChart.data = chartData
        
        logoImage.image = ImageUtility.getImageForSymbol(ticker.symbol)
    }
}
