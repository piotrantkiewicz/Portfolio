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
        lineChart.lineColor = .red
        titleLbl.font = UIFont(name: FontName.intertightBold.rawValue, size: 14)
    }
    
    func configure(with ticker: Ticker) {
        titleLbl.text = ticker.symbol
        subtitleLbl.text = ticker.name
        stockValueLbl.text = String(format: "%.2f", ticker.price)
        
        if let firstChange = ticker.change.first, let lastChange = ticker.change.last {
            let changeValue = lastChange.close - firstChange.close
            stockChangeLbl.text = String(format: "%.2f", changeValue)
        }
        
        let chartData = ticker.change.map { $0.close }
        lineChart.data = chartData
    }
}
