//
//  ViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 08/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class ContactListViewController: UITableViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBAction func cancel(_ sender: Any) {
    restarSearch()
  }
  
  // MARK: - Variables & Constants
  
  let contactList = ContactListDataPresenter(Repository.fake.contacts)
  let repository = Repository.fake
  var filtered = false
  
  // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        navigationController?.navigationBar.prefersLargeTitles = true
    }
  
  // MARK: - Table View
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = contactList.sectionsTitlesHeader().count
        return numberOfSections
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
      if let contactImage = contact.contactImage {
        cell.contactImage.image = contactImage
      } else {
        cell.contactImage.image = UIImage(named: "person-placeholder.jpg")
      }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactList.getSectionTitle(by: section)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contact = contactList.getContact(by: indexPath)
        contactList.remove(contact: contact)
        if contactList.deleteSection {
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            contactList.deleteSection = false
        } else {
             tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contactList.getContact(by: indexPath)
        performSegue(withIdentifier: "detailContact", sender: contact)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactList.sectionsTitlesHeader()
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
                let indexPath = self.contactList.getIndexPath(from: contact)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
            }
        }

    }
    

  // MARK: - Functions
  
    func restarSearch() {
      self.searchBar.text = nil
      self.contactList.removeFilter()
      if let searchField = self.searchBar.value(forKey: "searchField") as? UIControl {
        searchField.isEnabled = true
      }
      self.restore()
      self.searchBar.showsCancelButton = false
      tableView.reloadData()
      navigationController?.isToolbarHidden = true
    }
    
    
}

// MARK: - ContactEditionViewControllerDelegate

extension ContactListViewController: ContactEditionViewControllerDelegate {
    
    func contactEditionViewController(_ controller: ContactEditionViewController, didFinishAdding contact: Contact) {
        // Navigation
        navigationController?.popViewController(animated: true)
        let indexPath = contactList.getIndexPath(from: contact)
        tableView.beginUpdates()
        if contactList.updateSection {
            tableView.insertSections(IndexSet(integer: indexPath.section), with: .automatic)
            contactList.updateSection = false
        }
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
  
  func contactEditionViewController(_ controller: ContactEditionViewController, didFinishDeleting contact: Contact) {
    // Navigation
    navigationController?.popToViewController(self, animated: true)
    let indexPath = contactList.getIndexPath(from: contact)
    contactList.remove(contact: contact)
    if contactList.deleteSection {
      tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
      contactList.deleteSection = false
    } else {
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
  }
}

// MARK: - UISearchBarDelegate

extension ContactListViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
      searchField.clearButtonMode = UITextField.ViewMode.never
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  // We search while texting
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    restarSearch()
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    var textBefore = searchBar.text!
    var currentText : String {
       return (textBefore as NSString).replacingCharacters(in: range, with: text)
    }
    if !currentText.isEmpty {
      let contactsFound = contactList.setFilter(txt: currentText)

      if !contactsFound {
          setEmptyView(title: "Not Found", completion: ({() -> () in
            self.restarSearch()
          })
        )
      } else {
        restore()
      }
    } else {
      restarSearch()
    }
    tableView.reloadData()

    return true
  
  }
}

