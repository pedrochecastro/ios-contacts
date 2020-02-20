//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 20/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit



class ContactDetailViewController: UITableViewController {

  // MARK: - Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
  
  // MARK: - Variables
  
    var contact : Contact?
    weak var editionContactListDelegate: ContactListViewController?
    var editionActionHandler: ((Contact, Contact) -> Void)?
    private var picker = UIImagePickerController()

    
    @IBAction func editContact(_ sender: Any) {
        performSegue(withIdentifier: "editContact", sender: nil)
    }
  
  // MARK: - Lifecycle Methods
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        navigationItem.largeTitleDisplayMode = .never
        tableView.allowsSelection = false
        
        if let contact = contact {
            nameLabel?.text = contact.name
            phoneLabel?.text = contact.phoneNumber
          if let contactImage = contact.contactImage {
            self.contactImage.image = contactImage
          }
        }
    }
  
  // MARK: - Table View

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
  // MARK: - Navigation
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            if let contactEditionVC = segue.destination as? ContactEditionViewController,
                let editionActionHandler = editionActionHandler {
                contactEditionVC.delegate = editionContactListDelegate
                contactEditionVC.contact = contact
                contactEditionVC.editionsActionsHandler.append(editionActionHandler)
                contactEditionVC.editionsActionsHandler.append({ (contact, editedContact) in
                    self.nameLabel.text = editedContact.name
                    self.phoneLabel.text = editedContact.phoneNumber
                    self.contactImage.image = editedContact.contactImage
                  self.navigationController?.popToViewController(self, animated: true)
                })
            }
        }
        
    }
  
}
