//
//  UISearchBar+Extensions.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 06/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomSearchBar: UISearchBar {
    
    @IBInspectable var hideButton: Bool = false {
        didSet {
            if hideButton {
                self.createHideButtonOnKeyboard()
            }
        }
    }
    
    private func createHideButtonOnKeyboard() {
        let hideToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        hideToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hide: UIBarButtonItem = UIBarButtonItem(title: "▼", style: .done, target: self, action: #selector(self.hideButtonAction))
        
        let items = [flexSpace, hide]
        hideToolbar.items = items
        hideToolbar.sizeToFit()
        
        self.inputAccessoryView = hideToolbar
    }
    
    @objc func hideButtonAction() {
        self.resignFirstResponder()
    }
}
