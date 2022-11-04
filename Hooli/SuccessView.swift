import SwiftUI

struct SuccessView: UIViewRepresentable {
    let color: UIColor
    
    let checkMarkView = CheckMarkView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    func makeUIView(context: Context) -> CheckMarkView {
        checkMarkView.animatedLayerColor = color
        return checkMarkView
    }
    
    func updateUIView(_ uiView: CheckMarkView, context: Context) {
        checkMarkView.animated = true
        checkMarkView.animate()
    }
}

class CheckMarkView: UIView {
    public var initialLayerColor: UIColor = UIColor.clear {
        didSet {
            initialLayer.strokeColor = initialLayerColor.cgColor
        }
    }
    public var animatedLayerColor: UIColor = UIColor.systemGreen {
        didSet {
            animatedLayer?.strokeColor = animatedLayerColor.cgColor
        }
    }
    public var strokeWidth: CGFloat = 4 {
        didSet {
            initialLayer.lineWidth = strokeWidth
            animatedLayer?.lineWidth = strokeWidth
        }
    }
    public var animated: Bool = false {
        didSet {
            if animated {
                animatedLayer = createCheckmarkLayer(strokeColor: animatedLayerColor, strokeEnd: 0)
                layer.addSublayer(animatedLayer!)
            }
        }
    }
    
    // MARK: Private variables
    
    private lazy var initialLayer: CAShapeLayer = {
        return self.createCheckmarkLayer(strokeColor: self.initialLayerColor, strokeEnd: 1)
    }()
    private var animatedLayer: CAShapeLayer?
    
    // MARK: Overriding methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    // MARK: Public methods
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureView()
    }
    public func animate(duration: TimeInterval = 1.0) {
        guard let animatedLayer = animatedLayer else { return }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        
        animatedLayer.strokeEnd = 1
        animatedLayer.add(animation, forKey: "animateCheckmark")
    }
    
    // MARK: Private methods
    
    private func configureView() {
        backgroundColor = UIColor.clear
        initialLayerColor = UIColor.clear
        animatedLayerColor = .systemGreen
        strokeWidth = 8
        animated = true
        
        layer.addSublayer(initialLayer)
    }
    
    private func createCheckmarkLayer(strokeColor: UIColor, strokeEnd: CGFloat) -> CAShapeLayer {
        let scale = frame.width / 100
        let centerX = frame.size.width / 2
        let centerY = frame.size.height / 2
        let sixOclock = CGFloat(Double.pi / 2)
        
        let checkmarkPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: centerX, startAngle:  sixOclock, endAngle: sixOclock * 5, clockwise: true)
        checkmarkPath.move(to: CGPoint(x: centerX - 23 * scale, y: centerY - 1 * scale))
        checkmarkPath.addLine(to: CGPoint(x: centerX - 6 * scale, y: centerY + 15.9 * scale))
        checkmarkPath.addLine(to: CGPoint(x: centerX + 22.8 * scale, y: centerY - 13.4 * scale))
        
        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.lineWidth = strokeWidth
        checkmarkLayer.path = checkmarkPath.cgPath
        checkmarkLayer.strokeEnd = strokeEnd
        checkmarkLayer.strokeColor = strokeColor.cgColor
        checkmarkLayer.lineCap = CAShapeLayerLineCap.round
        checkmarkLayer.lineJoin = CAShapeLayerLineJoin.round
        
        return checkmarkLayer
    }
}
