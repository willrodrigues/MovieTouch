//
//  BaseViewController.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 01/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftItemsSupplementBackButton = true
        self.addBackgroundColor()
        self.addBackgroundImage()
        self.removeBackBarButtonItemText()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    }

    // MARK: - Functions
    private func addBackgroundColor() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
    }

    private func addBackgroundImage() {
        let image = UIImage(named: "StartupImage")
        let imageView = UIImageView(image: image)
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        //Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0/1.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        imageView.alpha = 0.1
        imageView.contentMode = .scaleAspectFit
    }
    
    func removeBackBarButtonItemText() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
}
