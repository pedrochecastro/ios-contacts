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
}


class ContactEditionViewController: UITableViewController {
    
    weak var delegate: ContactEditionViewControllerDelegate?
    weak var contact: Contact?
    weak var contactList: ContactList?
    var editionsActionsHandler: [((Contact) -> Void)] = []
  
    
    
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var addEditButton: UIButton!
  
  @IBAction func addContactImage(_ sender: Any) {
    launchPhotolibrary()
  }
  
  
  @IBAction func shareContact(_ sender: Any) {
    // text to share
    let text = "This is some text that I want to share."
    
    // set up activity view controller
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil )
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    // present the view controller
    self.present(activityViewController, animated: true, completion: nil)
    
  }
  
    @IBAction func done(_ sender: Any) {
        
        validate()
        
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
    
    @IBAction func cancelContactEdition() {
        navigationController?.popViewController(animated: true)
    }
    
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
    
    // MARK: - Custom Methods
    func editedContact(handler: @escaping(Contact) -> Void) {
        editionsActionsHandler.append(handler)
    }
    
    func validate () {
        do {
            
            let name = try nameTextField.validatedText(validationType: ValidatorType.name)
            let phone = try phoneTextField.validatedText(validationType: ValidatorType.phone)
            
            if let _ = contactList {
                let newContact = Contact(name: name, phoneNumber: phone)
                contactList?.add(contact: newContact)
                delegate?.contactEditionViewController(self, didFinishAdding: newContact)
            }
            else if let contact = contact {
                contact.name = name
                contact.phoneNumber = phone
                
                // Call to all viewcontroller  with edition handlers
                if !editionsActionsHandler.isEmpty {
                    editionsActionsHandler.forEach {
                        $0(contact)
                    }
                }
            }
            
        } catch(let error) {
            showAlert(for:(error as! ValidationError).message)
        }
    }
    
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
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
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if let _ = contactList {
      if section == 0 {
        return 0.01
      } else {
        return UITableView.automaticDimension
      }
    }
    return UITableView.automaticDimension
  }
    
}


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

extension ContactEditionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Handle image
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      contact?.contactImage = image
      contactImage.image = contact?.contactImage ?? image
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

