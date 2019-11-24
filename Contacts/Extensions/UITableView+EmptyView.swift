//
//  UITableView+EmptyView.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 22/11/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

extension UITableViewController {
  func setEmptyView(title: String, completion: @escaping ()->()) {
    let emptyView = UIView(frame: CGRect(x: self.tableView.center.x, y: self.tableView.center.y, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
    let titleLabel = UILabel()
    let button = UIButton(type: UIButton.ButtonType.system)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
//    button.setTitleColor(UIColor.black, for: .normal)
//    button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(button)
    titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    button.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
    button.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
//    button.addTarget(self, action: #selector(completion()), for: .touchUpInside)
    button.actionHandle(controlEvents: .touchUpInside, ForAction: completion)
    titleLabel.text = title
    //Buttom
    button.setTitle("Try Again", for: .normal)
   
    // The only tricky part is here:
    self.tableView.backgroundView = emptyView
    self.tableView.separatorStyle = .none
  }
  func restore() {
    self.tableView.backgroundView = nil
    self.tableView.separatorStyle = .singleLine
  }

}
