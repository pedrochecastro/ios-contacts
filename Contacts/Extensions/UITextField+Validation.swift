//
//  UITextField+Validation.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 11/11/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
