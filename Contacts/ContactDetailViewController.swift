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
    

}
