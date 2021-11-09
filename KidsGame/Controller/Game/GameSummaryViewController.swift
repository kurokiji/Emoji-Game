//
//  GameSummaryViewController.swift
//  KidsGame
//
//  Created by Daniel Torres on 1/11/21.
//

import UIKit

class GameSummaryViewController: UIViewController {

    @IBOutlet weak var finalPointsLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    var finalPoints: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.layer.cornerRadius = 30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let points = finalPoints {
            finalPointsLabel.text = "\(points) pts"
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        let gameController = ViewController()
        gameController.startGame()
    }
    
    
    @IBAction func saveRecord(_ sender: Any) {
    }
    
}
