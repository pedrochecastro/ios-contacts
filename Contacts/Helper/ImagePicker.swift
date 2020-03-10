//
//  ImagePicker.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 09/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import UIKit

public protocol ImagePickerDelegate: class {
  func didSelect(image: UIImage?)
  func didSelect(image: UIImage?, indexPath: IndexPath)
}


open class ImagePicker: NSObject {
  
  private let pickerController: UIImagePickerController
  private weak var presentationController: UIViewController?
  private weak var delegate: ImagePickerDelegate?
  var indexPath: IndexPath?
  
  public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
    self.pickerController = UIImagePickerController()
    
    super.init()
    
    self.presentationController = presentationController
    self.delegate = delegate
    
    self.pickerController.delegate = self
    self.pickerController.allowsEditing = true
    self.pickerController.mediaTypes = ["public.image"]
  }
  
  private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
    guard UIImagePickerController.isSourceTypeAvailable(type) else {
      return nil
    }
    
    return UIAlertAction(title: title, style: .default) { [unowned self] _ in
      self.pickerController.sourceType = type
      self.presentationController?.present(self.pickerController, animated: true)
    }
  }
  
  public func present(from sourceView: UIView) {
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    if let action = self.action(for: .camera, title: "Take photo") {
      alertController.addAction(action)
    }
    if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
      alertController.addAction(action)
    }
    if let action = self.action(for: .photoLibrary, title: "Photo library") {
      alertController.addAction(action)
    }
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      alertController.popoverPresentationController?.sourceView = sourceView
      alertController.popoverPresentationController?.sourceRect = sourceView.bounds
      alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
    }
    
    self.presentationController?.present(alertController, animated: true)
  }
  
  private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
    controller.dismiss(animated: true, completion: nil)
    
    if let indexPath = indexPath {
      self.delegate?.didSelect(image: image, indexPath: indexPath)
    } else {
      self.delegate?.didSelect(image: image)
    }
    
  }
}

extension ImagePicker: UIImagePickerControllerDelegate {

  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.pickerController(picker, didSelect: nil)
  }

  public func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[.editedImage] as? UIImage else {
      return self.pickerController(picker, didSelect: nil)
    }
    self.pickerController(picker, didSelect: image)
  }
}

extension ImagePicker: UINavigationControllerDelegate {
  
}

func didSelect(image: UIImage?) {
  
}

extension ImagePicker {
  
  
  func didSelect(image: UIImage?, indexPath: IndexPath) {
    
  }

  
  static func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
    
    let cgimage = image.cgImage!
    let contextImage: UIImage = UIImage(cgImage: cgimage)
    let contextSize: CGSize = contextImage.size
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
      posX = ((contextSize.width - contextSize.height) / 2)
      posY = 0
      cgwidth = contextSize.height
      cgheight = contextSize.height
    } else {
      posX = 0
      posY = ((contextSize.height - contextSize.width) / 2)
      cgwidth = contextSize.width
      cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = cgimage.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return image
  }
  
}
