
import UIKit

public struct Reaction {
    public let id: String
    public let icon: UIImage
    
    public init(id: String, icon: UIImage) {
        self.id  = id
        self.icon = icon
    }
}

extension Reaction: Equatable {
    public static func ==(lhs: Reaction, rhs: Reaction) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Reaction: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

extension Reaction {

  public struct facebook {
    public static var like: Reaction {
      return reactionWithId("like")
    }
    public static var love: Reaction {
      return reactionWithId("love")
    }
    public static var haha: Reaction {
      return reactionWithId("haha")
    }
    public static var wow: Reaction {
      return reactionWithId("wow")
    }
    public static var sad: Reaction {
      return reactionWithId("sad")
    }
    public static var angry: Reaction {
      return reactionWithId("angry")
    }

    public static let all: [Reaction] = [facebook.like, facebook.love, facebook.haha, facebook.wow, facebook.sad, facebook.angry]

    private static func reactionWithId(_ id: String) -> Reaction {
      return Reaction(id: id, icon: imageWithName(id))
    }

    private static func imageWithName(_ name: String) -> UIImage {
        return UIImage(named: name)!
    }
  }
}

extension Sequence where Iterator.Element: Hashable {
    /// Returns uniq elements in the sequence by keeping the order.
    func uniq() -> [Iterator.Element] {
        var alreadySeen: [Iterator.Element: Bool] = [:]
        return filter { alreadySeen.updateValue(true, forKey: $0) == nil }
    }
}
