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
  
  // MARK: - Variables
  weak var delegate: ContactEditionViewControllerDelegate?
  weak var contact: Contact?
  var imagePicker: ImagePicker!
  var editionsActionsHandler: [((Contact,Contact) -> Void)] = []
  
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
    //Gesture recognizer
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
    
    contactImage.isUserInteractionEnabled = true
    contactImage.addGestureRecognizer(tapGestureRecognizer)
    
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
    
    //ImagePicker
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    nameTextField.becomeFirstResponder()
  }
  
  
  // MARK: - Actions
  @IBAction func addContactImage(_ sender: Any) {
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
  }
  
  
  @IBAction func shareContact(_ sender: Any) {
    // Share contact information
    let text = "\(contact!.name) / \(contact!.phoneNumber)"
    
    // Set up activity view controller
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil )
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // Exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    // Present the view controller
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
      
      // Add new contact
      if self.contact == nil {
        
        if let name = nameTextField.text,
          let phoneNumber = phoneTextField.text {
          let newContact = Contact(name: name, phoneNumber: phoneNumber)
          newContact.contactImage = contactImage.image
          delegate?.contactEditionViewController(self, didFinishAdding: newContact)
        }
      }
      else {
        let editedContact = Contact()
        
        if let name = nameTextField.text,
          let phoneNumber = phoneTextField.text,
          let contactImage = contactImage.image {
          editedContact.name = name
          editedContact.phoneNumber = phoneNumber
          editedContact.contactImage = contactImage
          // Call to all viewcontroller  with edition handlers
          if !editionsActionsHandler.isEmpty {
            editionsActionsHandler.forEach {
              $0(self.contact!,editedContact)
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
      guard let _ = contact else { return 0 }
      return 2
    default:
      return 0
    }
    
  }
  
  // MARK: - Functions
  
  @objc func didTap(sender: UITapGestureRecognizer) {
    self.imagePicker.present(from: view)
  }
  
  func editedContact(handler: @escaping(Contact, Contact) -> Void) {
    editionsActionsHandler.append(handler)
  }
  
  func validate () -> Bool{
    do {
      
      _ = try nameTextField.validatedText(validationType: ValidatorType.name)
      
      //          let repository = Repository.shared.contactsSource
      //          _ = try nameTextField.validatedText(validationType: ValidatorType.existContact(repository: repository))
      //
      _ = try phoneTextField.validatedText(validationType: ValidatorType.phone)
      
      
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

extension ContactEditionViewController: ImagePickerDelegate {
  func didSelect(image: UIImage?, indexPath: IndexPath) {
    
  }
  
  func didSelect(image: UIImage?) {
    guard let image = image else { return }
    // Handle image
    let croppedImage: UIImage?
    croppedImage = ImagePicker.cropToBounds(image: image, width: 20.0, height: 20.0)
    contact?.contactImage = croppedImage
    contactImage.image = contact?.contactImage ?? image
    
    if let _ = contact {
      doneBarButton.isEnabled = true
    }
    addEditButton.setTitle("Edit Picture", for: .normal)
    
    // Dismiss de photolibrary
    self.dismiss(animated: true, completion: nil)
  }
}

