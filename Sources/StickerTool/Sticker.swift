import Foundation
import UIKit

/// Structure representing **Sticker object**
public struct Sticker: Identifiable, Hashable{
    
    ///A unique **identifier** for the *Sticker object*
    public let id = UUID()
    
    ///The  **received** for the *Sticker object*
    public var receivedImage: UIImage? = nil
    
    ///The **URL of the image** for the *Sticker object*
    public var imageURL: URL? = nil
    
    
    /// Func **to compute the hash value** for the *Sticker object*
    /// - Parameter hasher: The Hasher to use for combining the hash values.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
