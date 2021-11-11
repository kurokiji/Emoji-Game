//
//  MenuViewController.swift
//  KidsGame
//
//  Created by Daniel Torres on 4/11/21.
//

import UIKit
import FirebaseFirestore

class MenuViewController: UIViewController {
    private let db = Firestore.firestore()

    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var top1Name: UILabel!
    @IBOutlet weak var top1Points: UILabel!
    @IBOutlet weak var top2Name: UILabel!
    @IBOutlet weak var top2Points: UILabel!
    @IBOutlet weak var top3Name: UILabel!
    @IBOutlet weak var top3Points: UILabel!
    
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
 
        TopThreeController.pullRecords { user in
            self.top1Name.text = user.name
            self.top1Points.text = "\(user.points) pts"
        }
        
        menuBackground.layer.cornerRadius = 20
    }
    
   

    
    @IBAction func unwindToMenu(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        downloadRecords()
        
    }
    
    public func asignRecords(name: String, points: Int){
        top1Name.text = name
        top1Points.text = "\(points) pts"
    }
    
    public func downloadRecords() {
        
        let docRef = db.collection("topRecord")
        
        docRef.document("top1").getDocument { (document, error) in
            if let document = document, document.exists {
                if let top1Name = document.get("name") as? String {
                    self.top1Name.text = top1Name
                }
                if let top1Points = document.get("points") as? Int {
                    self.top1Points.text = "\(top1Points) pts"
                }
            }
        }
        
        docRef.document("top2").getDocument { (document, error) in
            if let document = document, document.exists {
                if let top2Name =  document.get("name") as? String {
                    self.top2Name.text = top2Name
                }
                if let top2Points = document.get("points") as? Int {
                    self.top2Points.text = "\(top2Points) pts"
                }
            }
        }
        
        docRef.document("top3").getDocument { (document, error) in
            if let document = document, document.exists {
                if let top3Name =  document.get("name") as? String {
                    self.top3Name.text = top3Name
                }
                if let top3Points = document.get("points") as? Int {
                    self.top3Points.text = "\(top3Points) pts"
                }
            }
        }
    }
    
}
