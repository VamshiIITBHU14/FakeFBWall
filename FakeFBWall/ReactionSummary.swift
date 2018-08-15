import UIKit

public class UIReactionControl: UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func setup() {}
    func update() {}
    
    final func setupAndUpdate() {
        setup()
        if superview != nil {
            update()
        }
    }
}


public final class ReactionSummary: UIReactionControl {
    private var summaryLayer = CAReactionSummaryLayer()
    
    public var reactions: [Reaction] = [] {
        didSet { setupAndUpdate() }
    }
  
    override func setup() {
        summaryLayer.removeFromSuperlayer()
        summaryLayer.reactions = reactions
        layer.addSublayer(summaryLayer)
    }
    
    override func update() {
        summaryLayer.frame  = bounds
        summaryLayer.setNeedsDisplay()
    }
}
