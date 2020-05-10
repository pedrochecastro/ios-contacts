//
//  ViewController.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 08/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {
  
  
  // MARK: - Variables & Constants
  let factory: ContactFactory
  let repository: Repository
  var contactList: ContactListPresenterImpl
  var imagePicker: ImagePicker?
  
  @IBOutlet weak var tableView: UITableView!
  
  
  // MARK: - Init
  required init?(coder: NSCoder) {
    // Assembly components
    self.factory = MockFactoryImpl()
    self.repository = Repository(contactFactory: factory)
    self.contactList = ContactListPresenterImpl(self.repository)
    self.factory.addPresenters(presenters: [contactList])
    super.init(coder: coder)
  }
  
  // MARK: - Outlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBAction func cancel(_ sender: Any) {
    restarSearch()
  }
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // UI
    tableView.dataSource = self
    tableView.delegate = self
    // createSpinnerView()
    navigationController?.navigationBar.prefersLargeTitles = true
    //Spinner Pending
    //GetContacts
    DispatchQueue.global().async {
      self.contactList.getContacts { result in
        switch result {
        case .success:
          self.tableView.reloadData() // Load Table View?
          print("Ok 😁")
        case .failure:
          print("Error Loading")
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
    // We apply this to a tableViewController. Change!
    //    tableView.restore()
    self.searchBar.showsCancelButton = false
    tableView.reloadData()
    navigationController?.isToolbarHidden = true
  }
  
  func createSpinnerView() {
    let child = SpinnerViewController()
    
    // add the spinner view controller
    addChild(child)
    child.view.frame = view.frame
    view.addSubview(child.view)
    child.didMove(toParent: self)
    
    // wait two seconds to simulate some work happening
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      // then remove the spinner view controller
      child.willMove(toParent: nil)
      child.view.removeFromSuperview()
      child.removeFromParent()
    }
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
          self.contactList.update(contact: contact, newContact: editedContact) { result in
            switch result {
            case .success:
              print ("Contact Updated")
              let indexPath = self.contactList.indexPathFrom(contact: editedContact)
              self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
              print ("Error")
            }
          }
        }
      }
    }
  }
  
}

// MARK: - TableView Delegate & DataSource
extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return contactList.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactList.contactsBy(section: section).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactlistItem",
                                             for: indexPath) as! CustomCell
    //Gesture recognizer
    let tapGestureRecognizer = CustomGestureRecognizer(target: self, action: #selector(didTap(sender:)), indexPath: indexPath)
    
    
    cell.contactImage.isUserInteractionEnabled = true
    cell.contactImage.addGestureRecognizer(tapGestureRecognizer)
    
    let contacts = contactList.contactsBy(indexPaths: [indexPath])
    let contact = contacts[0]
    cell.nameLabel.text = contact.name
    if let contactImage = contact.contactImage {
      cell.contactImage.image = contactImage
    } else {
      cell.contactImage.image = UIImage(named: "person-placeholder.jpg")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return contactList.titleForHeaderIn(section: section)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let contact = contactList.contactsBy(indexPaths: [indexPath])[0]
    contactList.remove(contact: contact) { result in
      switch result {
      case .success:
        print("Contact removed")
      case .failure:
        print ("Error deleteing...")
      }
    }
    if contactList.deleteSection {
      tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
      contactList.deleteSection = false
    } else {
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contact = contactList.contactsBy(indexPaths: [indexPath])[0]
    performSegue(withIdentifier: "detailContact", sender: contact)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return indexPath
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return contactList.sectionIndexTitles()
  }
  
}

// MARK: - ContactEditionViewControllerDelegate
extension ContactListViewController: ContactEditionViewControllerDelegate {
  
  func contactEditionViewController(_ controller: ContactEditionViewController, didFinishAdding contact: Contact) {
    // Navigation
    navigationController?.popViewController(animated: true)
    //Update presenter
    contactList.add(contact: contact) { result in
      switch result {
      case .success:
        print ("OK")
        let indexPath = contactList.indexPathFrom(contact: contact)
        //        tableView.beginUpdates()
        if contactList.updateSection {
          tableView.insertSections(IndexSet(integer: indexPath.section), with: .automatic)
          contactList.updateSection = false
        } else {
          tableView.insertRows(at: [indexPath], with: .automatic)
        }
      //        tableView.endUpdates()
      case .failure:
        print ("Error")
      }
    }
  }
  
  func contactEditionViewController(_ controller: ContactEditionViewController, didFinishDeleting contact: Contact) {
    // Navigation
    navigationController?.popToViewController(self, animated: true)
    let indexPath = contactList.indexPathFrom(contact: contact)
    
    // Update presenter
    contactList.remove(contact: contact) { result in
      switch result {
      case .success:
        print("OK")
        print("Number of sections \(tableView.numberOfSections)")
        if contactList.deleteSection {
          tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
          contactList.deleteSection = false
        } else {
          tableView.deleteRows(at: [indexPath], with: .automatic)
        }
      case .failure:
        print ("Error")
      }
    }
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
//      if !contactList.containsIndexedContact(with: currentText){
//        setEmptyView(title: "Not Found", completion: ({() -> () in
//          self.restarSearch()
//        }))
//      } else {
//        restore()
//      }
      
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
    let contact = contactList.contactsBy(indexPaths: [indexPath])[0]
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

