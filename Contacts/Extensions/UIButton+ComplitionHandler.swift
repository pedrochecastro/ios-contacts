//
//  UIButton+ComplitionHandler.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 22/11/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

extension UIButton {
  private func actionHandleBlock(action:(() -> Void)? = nil) {
    struct __ {
      static var action :(() -> Void)?
    }
    if action != nil {
      __.action = action
    } else {
      __.action?()
    }
  }
  
  @objc private func triggerActionHandleBlock() {
    self.actionHandleBlock()
  }
  
  func actionHandle(controlEvents control :UIControl.Event, ForAction action: @escaping () -> Void) {
    self.actionHandleBlock(action: action)
    self.addTarget(self, action: Selector(("triggerActionHandleBlock")), for: control)
  }
}
