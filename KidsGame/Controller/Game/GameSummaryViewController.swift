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

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 30
        if let points = finalPoints {
            finalPointsLabel.text = "\(points) pts"
            isModalInPresentation = true
        }
    }
}
