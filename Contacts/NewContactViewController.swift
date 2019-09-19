//
//  NewContactViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 12/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

protocol NewContacViewControllerDelegate: class {
    func newContacViewController(_ controller: NewContactViewController, didFinishAdding contact: Contact)
    func newContactViewController(_ controller: NewContactViewController, didFinishEdditing contact: Contact)
}



class NewContactViewController: UITableViewController {
    
    weak var delegate: NewContacViewControllerDelegate?
    weak var contactList: ContactList?
    weak var editedContact: Contact?
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBAction func done(_ sender: Any) {
        
        if let _ = contactList {
     
            if let textFieldText = textField.text {
                let newContact = Contact(name: textFieldText)
                contactList?.add(contact: newContact)
                delegate?.newContacViewController(self, didFinishAdding: newContact)
            }
        }
        else if let editedContact = editedContact {
            
            if let textFieldText = textField.text {
                editedContact.name = textFieldText
                delegate?.newContactViewController(self, didFinishEdditing: editedContact)
            }
            
        }
        
    }
    
    @IBAction func cancelNewContact() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        navigationItem.largeTitleDisplayMode = .never
        if let editContact = editedContact {
            navigationItem.title = "Edit Contact"
            textField.text = editContact.name
        }
        
        //Delegates
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    


}


extension NewContactViewController: UITextFieldDelegate {
    
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
