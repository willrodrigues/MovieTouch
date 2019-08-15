//
//  StartupAnimationViewController.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 01/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import UIKit

class StartupAnimationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imgStartup: UIImageView!
    
    // MARK: - ViewController Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.imgStartup.alpha = 0.1
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.performSegue(withIdentifier: "goToHome", sender: nil)
            })
        }
    }
}
