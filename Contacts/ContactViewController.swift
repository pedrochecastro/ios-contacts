//
//  ViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 08/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController {
    
    let contactList = ContactList()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
// MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.numberOfContacts()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactlistItem",
                                                 for: indexPath)
        
        if let label = cell.viewWithTag(1000) as? UILabel {
            let contact = contactList.getContact(index: indexPath.row)
            label.text = contact.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        contactList.removeContact(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "editContact", sender: contactList.getContact(index: indexPath.row))
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact" {
            if let newContactVC = segue.destination as? NewContactViewController {
                newContactVC.delegate = self
                newContactVC.contactList = contactList
            }
        } else if segue.identifier == "editContact" {
            if let newContactVC = segue.destination as? NewContactViewController {
                newContactVC.delegate = self
                newContactVC.editedContact = sender as? Contact
            }
        }

    }
    
}


extension ContactViewController: NewContacViewControllerDelegate {
    func newContactViewController(_ controller: NewContactViewController, didFinishEdditing contact: Contact) {
        if let rowIndex = contactList.getContactIndex(contact: contact){
            tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func newContacViewController(_ controller: NewContactViewController, didFinishAdding contact: Contact) {
         navigationController?.popViewController(animated: true)
         let rowIndex = contactList.numberOfContacts() - 1
         let indexPath = IndexPath(row: rowIndex, section: 0)
         tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
}
