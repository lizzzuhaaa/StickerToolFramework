import Foundation
import Photos
import SwiftUI
import UIKit

/// Class representing **Sticker Tools for stickers**
///
/// Helps to cooperate with operations on the stickers
public final class StickerTool: ObservableObject{
    
    /// The variable to have information of the sticker
    private var stickerInfo = Sticker()
    
    /// The variable of *the list of **Sticker objects** in temporary directory* of the app
    @Published public var allStickers:[Sticker] = []
    
    /// An initizializer of **StickerTool object**
    ///
    /// getting this object without an exact Sticker image
    public init (){
        self.allStickers = getAllStickers()
    }
    
    /// An initizializer of **StickerTool object**
    ///
    /// getting this object with an exact Sticker image
    public init(receivedImage: UIImage) {
        stickerInfo.receivedImage = receivedImage
        self.allStickers = getAllStickers()
    }
    
    /// A function to *change image extension and  size and save to the temporary directory* of the app
    /// - Parameters:
    ///   - extensionFormat: An extension format of the future sticker
    ///   - size: A max size of the side for the sticker
    public func performImageExtensionAndSize(extensionFormat: ExtensionFormat, size: Int){
        switch(extensionFormat){
        case .PNG:
            //perform size
            self.changeImageSize(size)
            //perform extension
            self.saveToFilesPNG()
        case .JPEG:
            //perform size
            self.changeImageSize(size)
            //perform extension
            self.saveToFilesJPEG()
        }
        
    }
    
    /// A function to *save sticker to Photo Gallery* using data from the temporary directory
    /// - Parameter typeExtension: An extension format of the image
    public func saveToPhotos(_ typeExtension: ExtensionFormat){
        var imageData: Data? = nil
        switch(typeExtension){
        case .PNG:
            imageData = stickerInfo.receivedImage?.pngData()
        case .JPEG:
            imageData = stickerInfo.receivedImage?.jpegData(compressionQuality: 0.8)
        }
        if imageData != nil{
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                let creationOptions = PHAssetResourceCreationOptions()
                creationRequest.addResource(with: .photo, data: imageData!, options: creationOptions)
            } completionHandler: { success, error in
                if success {
                    print("Image saved to Photos library.")
                } else {
                    if let error = error {
                        print("Error saving image: \(error)")
                    }
                }
            }
        }
    }
    
    /// A function to *save sticker to Photo Gallery* using data from an exact sticker
    /// - Parameter sticker: An exact Sticker object
    public func saveToPhotos(sticker: Sticker){
        if let imageURL = sticker.imageURL{
            do{
                let imageData = try? Data(contentsOf: imageURL)
                PHPhotoLibrary.shared().performChanges {
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    let creationOptions = PHAssetResourceCreationOptions()
                    creationRequest.addResource(with: .photo, data:  imageData!, options: creationOptions)
                } completionHandler: { success, error in
                    if success {
                        print("Image saved to Photos library.")
                    } else {
                        if let error = error {
                            print("Error saving image: \(error)")
                        }
                    }
                }
            }
        }
        else{
           print("Error with image")
        }
    }
    
    /// A function to *save an image as JPEG* in the temporary direction of the app
    private func saveToFilesJPEG(){
        if let receivedImage = self.stickerInfo.receivedImage{
            
            // UIImage to Data to PNG extension
            if let imageData = receivedImage.jpegData(compressionQuality: 0.8){
                // save new file to the temporary directory
                let temporaryDirectory = FileManager.default.temporaryDirectory

                let fileName = "\(createStickerName()).jpeg"
                let fileURL = temporaryDirectory.appendingPathComponent(fileName)
                
                do {
                    // write received data to the final file
                    try imageData.write(to: fileURL)
                    print("Image saved to temporary directory: \(fileURL)")
                    self.stickerInfo.imageURL = fileURL
                } catch {
                    print("Error saving image: \(error)")
                }
            }
        }
        else{
            print("No photo to perform")
        }
    }
    
    /// A function to *save an image as PNG* in the temporary direction of the app
    private func saveToFilesPNG()
    {
        if let receivedImage = self.stickerInfo.receivedImage{
            
            // UIImage to Data to PNG extension
            if let imageData = receivedImage.pngData(){
                // save new file to the temporary directory
                let temporaryDirectory = FileManager.default.temporaryDirectory

                let fileName = "\(createStickerName()).png"
                let fileURL = temporaryDirectory.appendingPathComponent(fileName)
                
                do {
                    // write received data to the final file
                    try imageData.write(to: fileURL)
                    print("Image saved to temporary directory: \(fileURL)")
                    self.stickerInfo.imageURL = fileURL
                } catch {
                    print("Error saving image: \(error)")
                }
            }
        }
        else{
            print("No photo to perform")
        }
    }
    
    /// A function to *change image sides size* due to given max possible value
    /// - Parameter newSize: A max possible value for the sides
    private func changeImageSize( _ newSize: Int){
        if var receivedImage = self.stickerInfo.receivedImage{
            //get size in pixels
            var imageSize = receivedImage.size
            var imageWidth = Int(imageSize.width)
            var imageHeight = Int(imageSize.height)
            
            //perform size
            while (imageWidth > newSize) || (imageHeight > newSize){
                
                if imageWidth > newSize {
                    receivedImage = receivedImage.sizeFitted(false, CGFloat(newSize))
                    self.stickerInfo.receivedImage = receivedImage
                }
                if imageHeight > newSize{
                    receivedImage = receivedImage.sizeFitted(true, CGFloat(newSize))
                    self.stickerInfo.receivedImage = receivedImage
                }
                
                imageSize = receivedImage.size
                imageWidth = Int(imageSize.width)
                imageHeight = Int(imageSize.height)
                
            }
        }
    }
    
    /// A function to receive *all stickers* from the temporary direction of the app
    /// - Returns: A list if the Sticker objects from the temporary direction of the app
    private func getAllStickers() -> [Sticker]{
        let temporaryDirectory = FileManager.default.temporaryDirectory
        do {
            // get only png and jpeg format from temporary directory
            let directoryContents = try FileManager.default.contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: nil)
            let pngImages = directoryContents.filter { ($0.pathExtension.lowercased() == "png")||($0.pathExtension.lowercased() == "jpeg") }
            
            //create list od sticker struct
            var stickers: [Sticker] = []
            for link in pngImages{
                let uiImage = UIImage(contentsOfFile: link.path())
                var sticker = Sticker()
                sticker.imageURL = link
                sticker.receivedImage = uiImage
                stickers.append(sticker)
            }
            
            return stickers
        } catch {
            print("Error getting contents of the temporary directory: \(error)")
            return []
        }
    }
    
    /// A function to *create a unique sticker name* due to its time of the creation
    /// - Returns: The name of the future sticker
    private func createStickerName() -> String{
        let date = Date().formatted(date: .numeric, time: .standard)
        return date.filter("0123456789.".contains)
    }
    
    /// A function to *get NSItemProvider* of the sticker file from the data
    /// - Parameters:
    ///   - extensionFormat: An extension for the future sticker
    ///   - size: An exact max size of the sides
    /// - Returns: NSItemProvider, or nil if there are problems with image data or an exact image is nil
    public func photoNSItemProvider(extensionFormat: ExtensionFormat, size: Int) -> NSItemProvider?{
        if let receivedImage = self.stickerInfo.receivedImage{
            changeImageSize(size)
            
            var imageData:Data?
            
            switch(extensionFormat){
            case .PNG:
                imageData = receivedImage.pngData()
            case .JPEG:
                imageData = receivedImage.jpegData(compressionQuality: 0.8)
            }
            // UIImage to Data to the required extension
            if imageData != nil{
                if let image = UIImage(data: imageData!){
                    return NSItemProvider(object: image as NSItemProviderWriting)
                }
            }
        }
        else{
            print("No photo to perform")
            return nil
        }
        return nil
    }
    
    /// A function to *get NSItemProvider*  from an exact Sticker object
    /// - Parameter sticker: An exact Sticker object
    /// - Returns: NSItemProvider, or nil if an exact image of the given Sticker is nil
    public func photoNSItemProvider(sticker: Sticker) -> NSItemProvider?{
        if let image = sticker.receivedImage{
            return NSItemProvider(object: image as NSItemProviderWriting)
        }
        else{
            print("No photo to perform")
            return nil
        }
    }
    
    
    /// A function to *navigate between stickers* due to the list of them
    /// - Parameters:
    ///   - currentSticker: A Sticker object from which you want to navigate
    ///   - navigateTo: A NavigationPhoto direction
    /// - Returns: The future Sticker if it is present, or nil
    public func navigation(currentSticker: Sticker, navigateTo: NavigationPhoto)->Sticker?{
        updateAllStickersList()

        guard let currentIndex = allStickers.firstIndex(where: { $0.imageURL == currentSticker.imageURL }) else {
            return nil
        }
        
        let nextIndex = currentIndex + navigateTo.rawValue
        
        guard nextIndex >= 0, nextIndex < allStickers.count else {
            return nil
        }
        
        return allStickers[nextIndex]
    }
    
    /// A function to *update all stickers list* in the temporary direction of the app
    public func updateAllStickersList(){
        self.allStickers = getAllStickers()
    }
    
    /// A function to *delete an exact sticker* from the temporary direction of the app
    /// - Parameter sticker: An exact Sticker object which will be deleted
    public func delete(sticker: Sticker){
        let fileManager = FileManager.default
        if let fileURL = sticker.imageURL{
            do {
                try fileManager.removeItem(atPath: fileURL.path())
                print("File deleted successfully")
            } catch {
                print("Error deleting file: \(error)")
            }
        }
        updateAllStickersList()
    }
    
    /// A function to *delete all stickers* from the temporary direction of the app
    public func deleteAllStickers(){
        let fileManager = FileManager.default
        for sticker in allStickers {
            if let fileURL = sticker.imageURL{
                do {
                    try fileManager.removeItem(atPath: fileURL.path())
                } catch {
                    print("Error deleting file: \(error)")
                }
            }
        }
        print("All files were deleted successfully")
        updateAllStickersList()
    }
}

/// An enumeration **to choose the direction to the next image**
///
/// - Next: 1
/// - Previous: -1
public enum NavigationPhoto: Int{
    case Next = 1
    case Previous = -1
}

/// An enumeration **to choose an exact extension of the image**
///
/// - PNG: PNG
/// - JPEG: JPEG
public enum ExtensionFormat: String{
    case PNG = "PNG"
    case JPEG = "JPEG"
}


