//
//  TextFieldsDelegate.swift
//  MemeMe 2.0
//
//  Created by Sergio Martin on 5/19/19.
//  Copyright © 2019 Sergio Martin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TextFieldsDelegate: NSObject, UITextFieldDelegate

class TextFieldsDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string.uppercased()) as NSString

        textField.text = newText as String
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ["TOP", "BOTTOM"].contains(textField.text!) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
