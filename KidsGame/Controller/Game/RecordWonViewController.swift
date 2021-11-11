//
//  RecordWonViewController.swift
//  KidsGame
//
//  Created by Daniel Torres on 9/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class RecordWonViewController: UIViewController {
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var placeText: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    var finalPoints: Int?
    var position: String?
    let threeTop = TopThreeController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50.0
        
        backgroundView.layer.cornerRadius = 30
        
        isModalInPresentation = true
        
        if let points = finalPoints {
            pointsLabel.text = "\(points) pts"
            
        switch checkPosition() {
        case "top1":
            placeText.text = "You won the first place with"
        case "top2":
            placeText.text = "You won the second place with"
        case "top3":
            placeText.text = "You won the third place with"
        default:
            placeText.text = "You won!!"
        }
            
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if let position = position {
            // no está recogiendo los datos, necesitas una instancia única de TopThreeController
            switch position {
            case "top1":
                TopThreeController.saveTop(recordPosition: "top2", name: TopThreeController.top1.name, points: TopThreeController.top1.points)
            case "top2":
                TopThreeController.saveTop(recordPosition: "top3", name:  TopThreeController.top2.name, points:  TopThreeController.top2.points)
            default:
                break
            }
            TopThreeController.saveTop(recordPosition: position, name: nameTextField.text ?? "No name", points: finalPoints!)
        }
    }
    
//    @IBAction func saveAndExit(_ sender: Any) {
//        if let position = position {
//            // no está recogiendo los datos, necesitas una instancia única de TopThreeController
//            switch position {
//            case "top1":
//                threeTop.saveTop(recordPosition: "top2", name: threeTop.top1.name, points: threeTop.top1.points)
//            case "top2":
//                threeTop.saveTop(recordPosition: "top3", name: threeTop.top2.name, points: threeTop.top2.points)
//            default:
//                break
//            }
//            threeTop.saveTop(recordPosition: position, name: nameTextField.text ?? "No name", points: finalPoints!)
//        }
//    }
//
    private func checkPosition() -> String{
        if finalPoints! > TopThreeController.top1.points{
            return "top1"
        } else if finalPoints! > TopThreeController.top2.points {
            return "top2"
        } else if finalPoints! > TopThreeController.top3.points {
            return "top3"
        } else {
            return "noTop"
        }
    }
    
}
