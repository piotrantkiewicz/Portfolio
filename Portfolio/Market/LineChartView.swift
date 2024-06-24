import UIKit

class LineChartView: UIView {
    
    var data: [Double] = [] {
        didSet { setNeedsDisplay() }
    }
    
    var horizontalMargin: CGFloat = 10
    var verticalMargin: CGFloat = 10
    //update according to figma
    var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    var shadowBlurRadius: CGFloat = 3.0
    var shadowColor: UIColor = .gray
    var lineColor: UIColor = .green
    var lineWidth: CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard data.count > 1 else { return }
        
        let path = UIBezierPath()
        
        let max = data.max() ?? 0
        let min = data.min() ?? 0
        let height = rect.height - verticalMargin * 2
        let width = rect.width - horizontalMargin * 2
        
        let scale = height / (max - min)
        
        for (index, value) in data.enumerated() {
            let x = CGFloat(index) * (width / CGFloat(data.count - 1)) + horizontalMargin
            let y = height - ((value - min) * scale) + verticalMargin
            
            let point = CGPoint(x: x, y: y)
            
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadowColor.cgColor)
        lineColor.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
        context?.restoreGState()
    }
}
