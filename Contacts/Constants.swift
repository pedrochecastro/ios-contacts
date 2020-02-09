//
//  Constants.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 03/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import Foundation

//
// MARK: - Constants
//
struct Constants {
  static let aToZ = (0..<26).map({String(UnicodeScalar("A".unicodeScalars.first!.value + $0) ?? "😡")})
}
