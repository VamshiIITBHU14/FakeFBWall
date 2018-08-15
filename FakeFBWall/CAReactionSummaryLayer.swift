
import UIKit

final class CAReactionSummaryLayer: CALayer {
  private var reactionsLayers: [(CALayer)] = [] {
    didSet {
      for (iconLayer) in oldValue {
        iconLayer.removeFromSuperlayer()
      }

      for index in 0 ..< reactionsLayers.count {
        let (iconLayer) = reactionsLayers[reactionsLayers.count - 1 - index]
        addSublayer(iconLayer)
      }
    }
  }

  private var reactionPairs: [(Reaction, Int)] = [] {
    didSet {
      reactionsLayers = reactionPairs.map({
        let iconLayer           = CALayer()
        iconLayer.contents      = $0.0.icon.cgImage
        iconLayer.masksToBounds = true
        iconLayer.borderColor   = UIColor.white.cgColor
        iconLayer.borderWidth   = 2
        iconLayer.contentsScale = UIScreen.main.scale

        return (iconLayer)
      })
    }
  }

  var reactions: [Reaction] = [] {
    didSet {
      reactionPairs = reactions.uniq().map({ reaction in
        let reactionCount = reactions.filter({ $0 == reaction }).count
        return (reaction, reactionCount)
      })
    }
  }

  // MARK: - Providing the Layer’s Content
  override func draw(in ctx: CGContext) {
    super.draw(in: ctx)
    for (index, (iconLayer)) in reactionsLayers.enumerated() {
      let rect = reactionFrameAt(index)
      updateIconLayer(iconLayer, in: rect)
    }
  }

  private func updateIconLayer(_ iconLayer: CALayer, in rect: CGRect) {
    var iconFrame        = rect
    iconFrame.size.width = iconFrame.height
    iconLayer.frame        = iconFrame
    iconLayer.cornerRadius = iconFrame.height / 2
  }

  func sizeToFit() -> CGSize {
    let lastReactionFrame = reactionFrameAt(reactionPairs.count - 1)
    let width: CGFloat    = lastReactionFrame.origin.x + lastReactionFrame.width
    return CGSize(width: width, height: bounds.height)
  }

  private func reactionFrameAt(_ index: Int) -> CGRect {
    guard index >= 0 else { return .zero }
    let iconHeight = bounds.height - 2 * 2
    return CGRect(x: (iconHeight - 3) * CGFloat(index), y: 2, width: iconHeight, height: iconHeight)
  }

}
