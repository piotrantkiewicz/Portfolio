import UIKit

class StockCardCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var stockValueLbl: UILabel!
    @IBOutlet weak var stockChangeLbl: UILabel!
    @IBOutlet weak var lineChart: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(with ticker: Ticker) {
        titleLbl.text = ticker.symbol
        subtitleLbl.text = ticker.name
        stockValueLbl.text = String(format: "%.2f", ticker.price)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "#EAEAEA")?.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        
        if let firstChange = ticker.change.first, let lastChange = ticker.change.last {
            let changeValue = lastChange.close - firstChange.close
            stockChangeLbl.text = String(format: "%.2f", changeValue)
        }
        
        let chartData = ticker.change.map { $0.close }
        lineChart.data = chartData
    }
}