//
//  TopThreeController.swift
//  KidsGame
//
//  Created by Daniel Torres on 9/11/21.
//

import Foundation
import FirebaseFirestore
import UIKit

class Networking {
    static private let db = Firestore.firestore()
    struct User {
        var name: String
        var points: Int
    }
    
    static func saveTop(recordPosition: String, name: String, points: Int){
        db.collection("topRecord").document(recordPosition).setData(["name":name, "points":points])
    }
    
    
    /*
     Para almacenar y obtener los resultados se ha obtado por usar la base de datos Firestore de google. Dentro de las opciones que se contemplaban estaban:
     - Almacenamiento como userDefault
     - Uso de Coredata para almacenar los datos. Estas dos opciones se han desechado al ser solo de uso local.
     - Uso de una api y acceso mediante Alamofire . Cuando comencé la tarea aún no tenía conocmientos suficiones para desplegar una API, por lo que se prescinció de esta opción.
     - Uso de Realtime databse de Google. Se precinció de esta herramienta ya que la usé el año pasado con una tarea de android.
     - Firestore database, la opción elegida ya que no había trabajado con ella.
     Firestore database permite el almacenamiento de datos en una base de datos alojada en Google y accesible mediante una librería que Google pone a disposición de los usuarios.
     Mediante unas simples líneas de código se puede almacenar y obtener los datos.
     */
    static func pullRecords(completion: @escaping ([User]) -> Void, hasError: @escaping (String) -> Void){
        let docRef = db.collection("topRecord")
        
        docRef.getDocuments { documents, error in
            if let error = error {
                 hasError("Error getting documents: \(error)")
            } else {
                var users: [User] = []
                for document in documents!.documents {
                    var user = User(name: "", points: 0)
                    if let name = document.get("name") as? String{
                        user.name = name
                    }
                    if let points = document.get("points") as? Int{
                        user.points = points
                    }
                    users.append(user)
                }
                completion(users)
            }
        }
    }
}
