//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 20/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit



class ContactDetailViewController: UITableViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var contact : Contact?
    
    @IBAction func editContact(_ sender: Any) {
        performSegue(withIdentifier: "editContact", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if let contact = contact {
            nameLabel.text = contact.name
            phoneLabel.text = contact.phoneNumber
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            if let contactEditionVC = segue.destination as? ContactEditionViewController {
                contactEditionVC.delegate = self
                contactEditionVC.editedContact = contact
            }
        }
        
    }
    

}

extension ContactDetailViewController: ContactEditionViewControllerDelegate {
    func contactEditionViewController(_ controller: ContactEditionViewController, didFinishAdding contact: Contact) {
        
    }
    
    func contactEditionViewController(_ controller: ContactEditionViewController, didFinishEdditing contact: Contact) {
         navigationController?.popViewController(animated: true)
         nameLabel.text = contact.name
         phoneLabel.text = contact.phoneNumber
    }
    
    
}