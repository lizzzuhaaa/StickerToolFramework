import Foundation
import UIKit

///An **enumeration** representing *Filter types* for the image
///
/// - Chrome: CIPhotoEffectChrome
/// - Fade: CIPhotoEffectFade
/// - Instant: CIPhotoEffectInstant
/// - Mono: CIPhotoEffectMono
/// - Noir: CIPhotoEffectNoir
/// - Process: CIPhotoEffectProcess
/// - Tonal: CIPhotoEffectTonal
/// - Transfer: CIPhotoEffectTransfer
public enum FilterType : String{
    
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}

public extension UIImage {
    /// A function to **change the orientation** of the *image*
    /// - Parameter orientationMode: The orientation mode from which will be the turning the image by a clockwise
    /// - Returns: A new UIImage with the new orientation
    func changeOrientation(_ orientationMode: Orientation) -> UIImage{
        
        switch (orientationMode){
        case .up:
            return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .left)
        case .left:
            return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .down)
        case .right:
            return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .up)
        default:
            return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .right)
        }
        
    }
    /// A function to **apply an exact filter** to the *image*
    /// - Parameter name: The name of the filter which will be applied
    /// - Returns: A new UIImage with the applied filter, or nil if the name of the filter is unavailable
    func applyFilter(_ name: String) -> UIImage?{
        switch(name){
        case "Chrome":
            return addFilter(filter: .Chrome)
        case "Fade":
            return addFilter(filter: .Fade)
        case "Instant":
            return addFilter(filter: .Instant)
        case "Mono":
            return addFilter(filter: .Mono)
        case "Noir":
            return addFilter(filter: .Noir)
        case "Process":
            return addFilter(filter: .Process)
        case "Tonal":
            return addFilter(filter: .Tonal)
        case "Transfer":
            return addFilter(filter: .Transfer)
            
        default:
            //Error filter name
            return nil
        }
        
    }
    
    /// A function to **apply an exact filter** to the *image*
    /// - Parameter filter: The filter type which will be applied
    /// - Returns: A new UIImage with the applied filter
    private func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
    
    /// A function to make **special size of sides** for the *image*
    /// - Parameters:
    ///   - heightPerform: A value to specify if we need to lower the height
    ///   - newPixelSize: A max count of the pixels
    /// - Returns: A new UIImage with applied side size
    func sizeFitted(_ heightPerform: Bool, _ newPixelSize :CGFloat) -> UIImage {
        //new size of the image
        let newSize: CGSize
        
        if heightPerform{
            let scale = newPixelSize / self.size.height
            let newWidth = self.size.width * scale
            newSize = CGSize(width: newWidth, height: newPixelSize)
        }
        else{
            let scale = newPixelSize / self.size.width
            let newHeight = self.size.height * scale
            newSize = CGSize(width: newPixelSize, height: newHeight)
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
