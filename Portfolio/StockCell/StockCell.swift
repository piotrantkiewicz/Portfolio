import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var lineChart: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lineChart.lineColor = .red
        titleLbl.font = UIFont(name: FontName.intertightBold.rawValue, size: 14)
    }
    
    func configure(with data: [Double]) {
        lineChart.data = data
    }
}
