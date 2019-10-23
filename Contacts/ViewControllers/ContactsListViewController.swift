//
//  ViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 08/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class ContactsListViewController: UITableViewController {
    
    let contactList = ContactList(Repository.local.contacts)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
// MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactList.sectionsTitlesHeader().count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.getContactList(by:section).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactlistItem",
                                                 for: indexPath) as! CustomCell
        let contacts = contactList.getContactList(by: indexPath.section)
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactList.getSectionTitle(by: section)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//      contactList.removeContact(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "detailContact", sender: contactList.getContact(indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact" {
            if let contactEditionVC = segue.destination as? ContactEditionViewController {
                contactEditionVC.delegate = self
                contactEditionVC.contactList = contactList
            }
        }
        else if segue.identifier == "detailContact" {
            if let contactDetailVC = segue.destination as? ContactDetailViewController {
                contactDetailVC.contact = sender as? Contact
                contactDetailVC.editionContactListDelegate = self
                contactDetailVC.editionActionHandler = { contact in
//                    if let rowIndex = self.contactList.getContactIndexPath(contact: contact){
//                        self.tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
//                    }
                }
                
            }
        }

    }
    
// MARK: - Custom Methods
    
    
}


extension ContactsListViewController: ContactEditionViewControllerDelegate {
    
    func contactEditionViewController(_ controller: ContactEditionViewController, didFinishAdding contact: Contact) {
        navigationController?.popViewController(animated: true)
//        if let rowIndex = contactList.getContactIndex(contact: contact) {
//            let indexPath = IndexPath(row: rowIndex, section: 0)
//            tableView.insertRows(at: [indexPath], with: .automatic)
//        }
    }
}

