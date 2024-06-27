import UIKit

class ImageUtility {
    
    static func getImageForSymbol(_ symbol: String) -> UIImage? {
        if let image = UIImage(named: symbol) {
            return image
        } else {
            return generateImageWithLetter(symbol.first)
        }
    }
    
    static func generateImageWithLetter(_ firstLetter: Character?) -> UIImage? {
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
