//
//  NewContactViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 12/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

protocol ContactEditionViewControllerDelegate: class {
    func contactEditionViewController(didFinishAdding contact: Contact)
    func contactEditionViewController(didFinishEdditing contact: Contact)
}


class ContactEditionViewController: UITableViewController {
    
    let multiDelegate = MulticastDelegate<ContactEditionViewControllerDelegate>()
    weak var editedContact: Contact?
    weak var contactList: ContactList?
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBAction func done(_ sender: Any) {
        
        if let _ = contactList {
     
            if let name = nameTextField.text,
               let phoneNumber = phoneTextField.text {
                let newContact = Contact(name: name, phoneNumber: phoneNumber)
                contactList?.add(contact: newContact)
                
                multiDelegate.invokeDelegates { contactEdition in
                    contactEdition.contactEditionViewController(didFinishAdding: newContact)
                }
                
//                delegate?.contactEditionViewController(self, didFinishAdding: newContact)
            }
        }
        else if let editedContact = editedContact {
            
            if let name = nameTextField.text,
               let phoneNumber = phoneTextField.text {
                editedContact.name = name
                editedContact.phoneNumber = phoneNumber
                multiDelegate.invokeDelegates { contactEdition in
                    contactEdition.contactEditionViewController(didFinishEdditing: editedContact)
                }
//                delegate?.contactEditionViewController(self, didFinishEdditing: editedContact)
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
        if let editContact = editedContact {
            navigationItem.title = "Edit Contact"
            nameTextField.text = editContact.name
            phoneTextField.text = editContact.phoneNumber
        }
        
        //Delegates
        nameTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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

extension ContactEditionViewControllerDelegate {
    func contactEditionViewController(didFinishAdding contact: Contact) {
        
    }
    func contactEditionViewController(didFinishEdditing contact: Contact) {
        
    }
}
