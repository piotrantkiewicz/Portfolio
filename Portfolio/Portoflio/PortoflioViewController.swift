import UIKit

class PortoflioViewController: UIViewController {
    
    @IBOutlet weak var portfolioLbl: UILabel!
    @IBOutlet weak var portolioValueLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBackgroundView: UIView!
    @IBOutlet weak var addNewStockBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portfolioLbl.font = UIFont(name: FontName.intertightRegular.rawValue, size: 14)
        portolioValueLbl.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 32)
        
        tableViewBackgroundView.clipsToBounds = true
        tableViewBackgroundView.layer.cornerRadius = 6
        tableViewBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addNewStockBtn.titleLabel?.font = UIFont(name: FontName.intertightSemiBold.rawValue, size: 14)
        addNewStockBtn.setCornerRadius(16)
        
    }
    
    @IBAction func addNewStockBtnTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MarketViewController") as! MarketViewController
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
}
