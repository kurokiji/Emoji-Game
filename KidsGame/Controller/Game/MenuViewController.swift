//
//  MenuViewController.swift
//  KidsGame
//
//  Created by Daniel Torres on 4/11/21.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuBackground: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        menuBackground.layer.cornerRadius = 20
    }
    
}
