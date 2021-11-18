//
//  RecordWonViewController.swift
//  KidsGame
//
//  Created by Daniel Torres on 9/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class GameSummaryViewController: UIViewController {
    
    @IBOutlet weak var greetLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var placeText: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var saveRecordButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var fieldTobuttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointsToButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var greetToTextConstraint: NSLayoutConstraint!
    
    var finalPoints: Int?
    var isRecord: Bool?
    var records: [Networking.User]?
    var finalPosition: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Librería obtenida en Cocoapods para gestionar el comportamiento de los textviews en pantalla cuando aparece el teclado, impidiendo que este se solape e impida ver el textview durante su edición.
         */
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50.0
        
        backgroundView.layer.cornerRadius = 30
        isModalInPresentation = true
        
        if let points = finalPoints {
            pointsLabel.text = "\(points) pts"
            Networking.pullRecords { users in
                self.records = users
                let position = self.checkPosition(records: users, finalPoints: self.finalPoints!)
                self.finalPosition = position.position
                if position.position == "noTop" {
                    self.noRecordWon(message: position.message)
                } else {
                    self.recordWon(message: position.message)
                }
                
            } hasError: { error in
                self.noRecordWon(message: "No se puede registrar tu record")
            }
        }
    }
    
    public func noRecordWon(message: String){
        isRecord = false
        greetLabel.text = "Well Done!"
        placeText.text = message
        nameTextField.isHidden = true
        saveRecordButton.setTitle("Play again!", for: .normal)
        exitButton.setTitle("Exit", for: .normal)
        fieldTobuttonConstraint.isActive = false
        pointsToButtonConstraint.isActive = true
    }
    
    public func recordWon(message: String){
        isRecord = true
        greetLabel.text = "Congratulations!"
        placeText.text = message
        nameTextField.isHidden = false
        saveRecordButton.setTitle("Save record and play!", for: .normal)
        exitButton.setTitle("Save and exit", for: .normal)
    }
    
    
    @IBAction func saveAndPlay(_ sender: Any) {
        if isRecord! {
            if let position = finalPosition {
                // no está recogiendo los datos, necesitas una instancia única de TopThreeController
                if let records = records {
                    switch position {
                    case "top1":
                        Networking.saveTop(recordPosition: "top2", name: records[0].name, points: records[0].points)
                    case "top2":
                        Networking.saveTop(recordPosition: "top3", name:  records[1].name, points:  records[1].points)
                    default:
                        break
                    }
                }
                Networking.saveTop(recordPosition: position, name: nameTextField.text ?? "No name", points: finalPoints!)
            }
        }
    }
    
    private func checkPosition(records: [Networking.User], finalPoints: Int) -> (position: String, message: String){
        if finalPoints > records[0].points{
            return ("top1", "You won the first place with")
        } else if finalPoints > records[1].points {
            return ("top2", "You won the second place with")
        } else if finalPoints > records[2].points {
            return ("top3","You won the third place with")
        } else {
            return ("noTop","But no records! You earned")
        }
    }
    
}
