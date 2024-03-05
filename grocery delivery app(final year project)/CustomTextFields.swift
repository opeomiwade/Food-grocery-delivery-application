//
//  CustomTextFields.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 21/11/2022.
//

import UIKit

class CustomTextFields: UITextField {
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = super.placeholderRect(forBounds: bounds)
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = super.editingRect(forBounds: bounds)
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = super.textRect(forBounds: bounds)
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
    }
}
