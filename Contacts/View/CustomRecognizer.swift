//
//  CustomRecognizer.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 11/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import UIKit

class CustomGestureRecognizer : UITapGestureRecognizer {
  
  var indexPath : IndexPath?
  // any more custom variables here
  
  init(target: AnyObject?, action: Selector, indexPath: IndexPath) {
    super.init(target: target, action: action)
    self.indexPath = indexPath
  }
  
}
