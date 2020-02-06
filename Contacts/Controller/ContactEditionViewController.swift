//
//  NewContactViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 12/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ContactEditionViewControllerDelegate: class {
    func contactEditionViewController(_ controller: ContactEditionViewController, didFinishAdding contact: Contact)
    func contactEditionViewController(_ controller: ContactEditionViewController, didFinishDeleting contact: Contact)
}


class ContactEditionViewController: UITableViewController {
  
  // MARK: - Variable
    
    weak var delegate: ContactEditionViewControllerDelegate?
    weak var contact: Contact?
    weak var contactList: ContactList?
    var editionsActionsHandler: [((Contact) -> Void)] = []
  
  // MARK: - Outlet
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var addEditButton: UIButton!
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UI
    navigationItem.largeTitleDisplayMode = .never
    if let editContact = contact {
      navigationItem.title = "Edit Contact"
      nameTextField?.text = editContact.name
      phoneTextField?.text = editContact.phoneNumber
      
      if let customImage = editContact.contactImage {
        contactImage.image = customImage
        addEditButton.setTitle("Edit Picture", for: .normal)
      }
    }
    
    //Delegates
    nameTextField?.delegate = self
    phoneTextField?.delegate = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    nameTextField.becomeFirstResponder()
  }
  
  
  // MARK: - IBAction
  
  @IBAction func addContactImage(_ sender: Any) {
    launchPhotolibrary()
  }
  
  
  @IBAction func shareContact(_ sender: Any) {
    // Share contact information
    let text = "\(contact!.name) / \(contact!.phoneNumber)"
    
    // set up activity view controller
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil )
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    // present the view controller
    self.present(activityViewController, animated: true, completion: nil)
    
  }
  
  @IBAction func deleteContact(_ sender: Any) {
    // UIAlert
    showAlert(title: "Delete Contact", message: "Are you sure?",
              actions:
              [UIAlertAction(title: "Yes", style: .default, handler: {_ in
                self.delegate?.contactEditionViewController(self, didFinishDeleting: self.contact!)}),
              UIAlertAction(title: "No", style: .default, handler:{action in print("Click NO")})])
    // Navigation
    
    // Update
    
  }

  
    @IBAction func done(_ sender: Any) {
        
      if validate() {
        
                if let _ = contactList {
        
                    if let name = nameTextField.text,
                       let phoneNumber = phoneTextField.text {
                        let newContact = Contact(name: name, phoneNumber: phoneNumber)
                        newContact.contactImage = contactImage.image
                        contactList?.add(contact: newContact)
                        delegate?.contactEditionViewController(self, didFinishAdding: newContact)
                    }
                }
                else if let contact = contact {
        
                    if let name = nameTextField.text,
                       let phoneNumber = phoneTextField.text,
                       let contactImage = contactImage.image {
                        contact.name = name
                        contact.phoneNumber = phoneNumber
                        contact.contactImage = contactImage
        
                        // Call to all viewcontroller  with edition handlers
                        if !editionsActionsHandler.isEmpty {
                            editionsActionsHandler.forEach {
                                $0(contact)
                            }
                        }
                    }
                }
      }
    }
    
    @IBAction func cancelContactEdition() {
        navigationController?.popViewController(animated: true)
    }
  
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        switch section {
        case 0:
          return 3
        case 1:
          guard let _ = contact else { return 0}
          return 2
        default:
          return 0
        }
      
    }
    
    // MARK: - Functions
  
    func editedContact(handler: @escaping(Contact) -> Void) {
        editionsActionsHandler.append(handler)
    }
    
    func validate () -> Bool{
        do {
            
          _ = try nameTextField.validatedText(validationType: ValidatorType.name)
          _ = try phoneTextField.validatedText(validationType: ValidatorType.phone)
            
//            if let _ = contactList {
//                let newContact = Contact(name: name, phoneNumber: phone)
//                contactList?.add(contact: newContact)
//                delegate?.contactEditionViewController(self, didFinishAdding: newContact)
//            }
//            else if let contact = contact {
//                contact.name = name
//                contact.phoneNumber = phone
//
//                // Call to all viewcontroller  with edition handlers
//                if !editionsActionsHandler.isEmpty {
//                    editionsActionsHandler.forEach {
//                        $0(contact)
//                    }
//                }
//            }
//
          return true
        } catch(let error) {
          showAlert(title: nil, message: (error as! ValidationError).message,
                    actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
      return false
    }
    
  func showAlert(title alertTitle: String?, message alertMessage: String?, actions: [UIAlertAction] ){

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        actions.forEach {
            alertController.addAction($0)
        }
        present(alertController, animated: true, completion: nil)
    }
  
  func launchPhotolibrary() {
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
      let myPickerController = UIImagePickerController()
      myPickerController.delegate = self
      myPickerController.sourceType = .photoLibrary
      self.present(myPickerController, animated: true, completion: nil)
    }
    
  }
  
  func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
    
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

// MARK: - UITextFieldDelegate

extension ContactEditionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let stringRange = Range(range,  in:   oldText) else {
            return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with:   string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        
        return true
        
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ContactEditionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Handle image
    let croppedImage: UIImage?
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      croppedImage = cropToBounds(image: image, width: 20.0, height: 20.0)
      contact?.contactImage = croppedImage
      contactImage.image = contact?.contactImage ?? croppedImage
    } else{
      print("Something went wrong in  image")
    }
    
    if let _ = contact {
      doneBarButton.isEnabled = true
    }
    addEditButton.setTitle("Edit Picture", for: .normal)
  
    // Dismiss de photolibrary
    self.dismiss(animated: true, completion: nil)
  }
  
}

