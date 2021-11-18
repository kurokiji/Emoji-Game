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
    @IBOutlet weak var internetStatusBackground: UIView!
    @IBOutlet weak var recordsBackground: UIView!
    
    @IBOutlet weak var top1Name: UILabel!
    @IBOutlet weak var top1Points: UILabel!
    @IBOutlet weak var top2Name: UILabel!
    @IBOutlet weak var top2Points: UILabel!
    @IBOutlet weak var top3Name: UILabel!
    @IBOutlet weak var top3Points: UILabel!
    
    @IBOutlet weak var connectionStatusView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noInternetConnectionLabel: UITextView!
    
    override func viewDidLoad() {
        downloadRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        confLoadView(internetLabelConfig: false, spinnerConfig: true, connectionViewConfig: true)
        menuBackground.layer.cornerRadius = 20
        internetStatusBackground.layer.cornerRadius = 20
        recordsBackground.layer.cornerRadius = 20
    }
    
    @IBAction func unwindToMenu(_ unwindSegue: UIStoryboardSegue) {
        downloadRecords()
        confLoadView(internetLabelConfig: false, spinnerConfig: true, connectionViewConfig: true)
    }
    
    
    public func asignRecords(name: String, points: Int){
        top1Name.text = name
        top1Points.text = "\(points) pts"
    }
    
    public func downloadRecords() {
        Networking.pullRecords { users in
            if !users.isEmpty {
                self.top1Name.text = users[0].name
                self.top1Points.text = "\(users[0].points) pts"
                self.top2Name.text = users[1].name
                self.top2Points.text = "\(users[1].points) pts"
                self.top3Name.text = users[2].name
                self.top3Points.text = "\(users[2].points) pts"
                self.confLoadView(internetLabelConfig: false, spinnerConfig: false, connectionViewConfig: false)
            } else {
                self.confLoadView(internetLabelConfig: true, spinnerConfig: false, connectionViewConfig: true)
            }
        } hasError: {error in
            print(error)
            self.confLoadView(internetLabelConfig: true, spinnerConfig: false, connectionViewConfig: true)
        }
    }
    
    private func confLoadView(internetLabelConfig: Bool, spinnerConfig: Bool, connectionViewConfig: Bool){
        if internetLabelConfig {
            noInternetConnectionLabel.isHidden = false
        } else{
            noInternetConnectionLabel.isHidden = true
        }
        if spinnerConfig{
            spinner.startAnimating()
            spinner.isHidden = false
        } else {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
        
        if connectionViewConfig {
            connectionStatusView.isHidden = false
        } else {
            connectionStatusView.isHidden = true
        }
    }
    
    
    
    
}
