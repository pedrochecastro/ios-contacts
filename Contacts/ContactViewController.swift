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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.numberOfContacts()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactlistItem",
                                                 for: indexPath)
        
        if let label = cell.viewWithTag(1000) as? UILabel {
            let contact = contactList.getContactBy(position: indexPath.row)
            label.text = contact.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }


// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact" {
            if let newContactVC = segue.destination as? NewContactViewController {
                newContactVC.delegate = self
                newContactVC.contactList = contactList
            }
        }
    }
    
}


extension ContactViewController: NewContacViewControllerDelegate {
    func newContacViewController(_ controller: NewContactViewController, didFinishAdding contact: Contact) {
         navigationController?.popViewController(animated: true)
         let rowIndex = contactList.numberOfContacts() - 1
         let indexPath = IndexPath(row: rowIndex, section: 0)
         tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
}

