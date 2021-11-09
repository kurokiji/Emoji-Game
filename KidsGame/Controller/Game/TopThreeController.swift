//
//  TopThreeController.swift
//  KidsGame
//
//  Created by Daniel Torres on 9/11/21.
//

import Foundation
import FirebaseFirestore

class TopThreeController {
    
    private let db = Firestore.firestore()
    var top1 = User.init(name: "", points: 0)
    var top2 = User.init(name: "", points: 0)
    var top3 = User.init(name: "", points: 0)
    
    struct User {
        var name: String
        var points: Int
    }
    
    func saveTop(recordPosition: String, name: String, points: Int){
        db.collection("topRecord").document(recordPosition).setData(["name":name, "points":points])
    }
    
    func pullRecords(){
        let docRef = db.collection("topRecord")
        
        docRef.document("top1").getDocument { (document, error) in
            if let document = document, document.exists {
                if let top1Name = document.get("name") as? String {
                    self.top1.name = top1Name
                }
                if let top1Points = document.get("points") as? Int {
                    self.top1.points = top1Points
                }
            }
        }
        
        docRef.document("top2").getDocument { (document, error) in
            if let document = document, document.exists {
                if let top2Name =  document.get("name") as? String {
                    self.top2.name = top2Name
                }
                if let top2Points = document.get("points") as? Int {
                    self.top2.points = top2Points
                }
            }
        }
        
        docRef.document("top3").getDocument { (document, error) in
            if let document = document, document.exists {
                if let top3Name =  document.get("name") as? String {
                    self.top3.name = top3Name
                }
                if let top3Points = document.get("points") as? Int {
                    self.top3.points = top3Points
                }
            }
        }
    }
    
}
