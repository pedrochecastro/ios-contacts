//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 20/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    
    
    @IBAction func editContact(_ sender: Any) {
        performSegue(withIdentifier: "editContact", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    

}
