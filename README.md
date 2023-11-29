# StickerTool-Framework
This framework helps in modifying images and preparing them for the future stickers

## Features
- Uploading, exporting and saving images to Photo Gallery and the temporary directory of your app
- Managing all images in the temporary directory
- Ability to perform the needed extension of your images
- Editing photos with filters, orientation mode and max required size of the sides in pixels
- Basic preparation for the image for the implemenetation of its drag n drop
- A mechanism for the navigation between photos from the temporary directory of the app`s view
- Getting information about the Stickers in the temporary directory
- Different structures and enumerations to deal with Stickers

## How to install StickerTool?
Use _Swift Package Manager_: from https://github.com/lizzzuhaaa/StickerToolFramework
Use _CocoaPods_: pod 'StickerTool' from https://github.com/lizzzuhaaa/StickerTool-Framework

## Instructions for the future usage
- Install _StickerTool_
- Import _StickerTool_ to your class
- Call the needed initializer of _StickerTool_ class:
  StickerTool() or StickerTool(receivedImage: UIImage)
- Deal with the stucture _Sticker_ and call some _functions_:
  StickerTool().delete(sticker: Sticker)
- Try _image filters_:
  yourImage.applyFilter(_ name: String)
- Explore and try it!
