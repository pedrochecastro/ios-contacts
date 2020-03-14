//
//  ViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 08/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class ContactListViewController: UITableViewController {
  
  // MARK: - Variables & Constants
  let contactList = ContactListDataPresenter(Repository.fake)
  var imagePicker: ImagePicker?
  
  
  // MARK: - Outlets
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBAction func cancel(_ sender: Any) {
    restarSearch()
  }
  
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
      //Gesture recognizer
      let tapGestureRecognizer = CustomGestureRecognizer(target: self, action: #selector(didTap(sender:)), indexPath: indexPath)
      
 
      cell.contactImage.isUserInteractionEnabled = true
      cell.contactImage.addGestureRecognizer(tapGestureRecognizer)
      
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
//                contactEditionVC.repository = Repository.coredata
            }
        }
        else if segue.identifier == "detailContact" {
            if let contactDetailVC = segue.destination as? ContactDetailViewController {
                contactDetailVC.contact = sender as? Contact
                contactDetailVC.editionContactListDelegate = self
                contactDetailVC.editionActionHandler = { (contact, editedContact) in
                self.contactList.update(contact: contact, editedContact: editedContact)
                let indexPath = self.contactList.getIndexPath(from: editedContact)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
            }
        }

    }
  // MARK: - Functions
  
  @objc func didTap(sender: CustomGestureRecognizer) {// present the view controller
    //ImagePicker
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    self.imagePicker?.indexPath = sender.indexPath
    self.imagePicker?.present(from: view)
  }
  
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
        //Update presenter
        contactList.add(contact: contact)
      
        let indexPath = contactList.getIndexPath(from: contact)
//        tableView.beginUpdates()
      print("Number of sections \(tableView.numberOfSections)")
        if contactList.updateSection {
            tableView.insertSections(IndexSet(integer: indexPath.section), with: .automatic)
            contactList.updateSection = false
        }
        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
      print("Number of sections \(tableView.numberOfSections)")
    }
  
  func contactEditionViewController(_ controller: ContactEditionViewController, didFinishDeleting contact: Contact) {
    // Navigation
    navigationController?.popToViewController(self, animated: true)
    let indexPath = contactList.getIndexPath(from: contact)
    
    // Update presenter
     contactList.remove(contact: contact)

    print("Number of sections \(tableView.numberOfSections)")
//    if contactList.deleteSection {
//      print("Section: \(indexPath.section)")
//      tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
//      contactList.deleteSection = false
//    } else {
      tableView.deleteRows(at: [indexPath], with: .automatic)
//    }
//    print("Number of sections \(tableView.numberOfSections)")

  }
}

// MARK: - UISearchBarDelegate

extension ContactListViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    if (searchBar.value(forKey: "searchField") as? UITextField) != nil {
//      searchField.clearButtonMode = UITextField.ViewMode.never
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
      contactList.filter = currentText
      if !contactList.containsIndexedContact(with: currentText){
                  setEmptyView(title: "Not Found", completion: ({() -> () in
                    self.restarSearch()
                  }))
      } else {
        restore()
      }

    } else {
      restarSearch()
    }
    tableView.reloadData()

    return true
  
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if (searchText == "") { restarSearch()}
  }
}

// MARK: - ImagePickerDelegate

extension ContactListViewController: ImagePickerDelegate {
  func didSelect(image: UIImage?, indexPath: IndexPath) {
    guard let image = image else { return }
    // Handle image
    // Add image to contact
    let contact = contactList.getContact(by: indexPath)
    let croppedImage: UIImage?
    croppedImage = ImagePicker.cropToBounds(image: image, width: 20.0, height: 20.0)
    contact.contactImage = croppedImage
    
    // Update in the indexpath
    tableView.beginUpdates()
    tableView.reloadRows(at: [indexPath], with: .automatic)
    tableView.endUpdates()
    
    
    // Dismiss de photolibrary
    self.dismiss(animated: true, completion: nil)
    
  }
  
  func didSelect(image: UIImage?) {

  }
  
}

