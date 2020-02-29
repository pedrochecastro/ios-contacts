//
//  String+LocalizedError.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 06/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import Foundation

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}
