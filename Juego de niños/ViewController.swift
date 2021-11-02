//
//  ViewController.swift
//  Juego de niños
//
//  Created by Daniel Torres on 16/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var icons: UICollectionView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var targetIcon: UILabel!
    @IBOutlet weak var roundTimeLabel: UILabel!
    
    var gameTimer : Timer?
    var roundTimer: Timer?
    var gameTime = 30
    var roundTime = 0
    var points = 0
    var iconsLibrary = ["🍆", "🥰", "☎️", "📺", "🦷", "🙏🏻", "🔥", "😭", "🤣"]
    var iconsShuffled: [String]?
    var isPlaying: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        iconsShuffled = iconsLibrary.shuffled()
        icons.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        icons.delegate = self
        icons.dataSource = self
        setLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isPlaying = false
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startGame()
    }
    
    private func randomArray(icons: [String]) -> [String]{
        return icons.shuffled()
    }

    private func startGame(){
        isPlaying = true
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireGameTimer), userInfo: nil, repeats: true)
        roundTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireRoundTimer), userInfo: nil, repeats: true)
            targetIcon.text = iconsShuffled![Int.random(in: 0...iconsLibrary.count-1)]
    }
    
    private func endGame(){
        isPlaying = false
        roundTimer?.invalidate()
        gameTimer?.invalidate()
        performSegue(withIdentifier: "showGameSummary", sender: nil)
    }
    
    private func setLabels(){
        timeLabel.text = "\(time) secs"
        pointsLabel.text = "0 pts"
        targetIcon.text = "▶️"
        roundTimeLabel.text = ""
    }
    
    private func checkAnswer(selectedIcon: Int) {
        if isPlaying! {
            if targetIcon.text == iconsShuffled![selectedIcon] {
                rightAnswer()
            } else {
                wrongAnswer()
            }
        }
    }
    
    private func rightAnswer() {
        print((100 - roundTime))
        points += (100 - roundTime)
        pointsLabel.text = "\(points) pts"
        roundTimer?.invalidate()
        roundTime = 0
        iconsShuffled = iconsLibrary.shuffled()
        icons.reloadData()
        targetIcon.text = iconsShuffled![Int.random(in: 0...iconsLibrary.count-1)]
        roundTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireRoundTimer), userInfo: nil, repeats: true)
    }
    
    private func wrongAnswer() {
        // haptic error
        // red background on header 0.5 secs
    }
    
    @objc func fireGameTimer() {
        gameTime -= 1
        timeLabel.text = "\(String(format: "%02d", gameTime)) secs"
        if gameTime <= 0 {
            gameTimer?.invalidate()
            roundTimer?.invalidate()
            endGame()
        }
    }
    
    @objc func fireRoundTimer(){
        roundTime += 1
        roundTimeLabel.text = "\(String(format: "%02d", roundTime))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGameSummary" {
            let controller = segue.destination as! GameSummaryViewController
            controller.finalPoints = points
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        checkAnswer(selectedIcon: indexPath[1])
        //print("you tapped \(iconsShuffled![indexPath[1]])")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
        cell.configure(with: iconsShuffled![indexPath[1]])
        
        return cell
    }
}

//extension ViewController: UICollectionViewDelegateFlowLayout {
//}
