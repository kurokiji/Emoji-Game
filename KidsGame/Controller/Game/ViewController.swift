//
//  ViewController.swift
//  KidsGame
//
//  Created by Daniel Torres on 16/10/21.
//

import UIKit
import Haptica
import Peep
import FirebaseAnalytics

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var icons: UICollectionView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var targetIcon: UILabel!
    @IBOutlet weak var roundTimeLabel: UILabel!
    @IBOutlet weak var titleBar: UIView!
    
    // MARK: - Game vairables
    let initialGameTime = 30
    let iconsLibraries = [["🍆", "🥰", "☎️", "📺", "🦷", "🙏🏻", "🔥", "😭", "🤣"],
                          ["🍟", "🍡", "🧃", "🍚", "🥐", "🥭", "🍉", "🍋", "🌮"],
                          ["🐶", "🐱", "🐨", "🐹", "🐰", "🦊", "🐻", "🐼", "🐷"],
                          ["👩🏼‍💻", "👨🏾‍🔬", "🦹🏼‍♀️", "👨🏻‍🔧", "👩🏾‍🏭", "🧑🏽‍🌾", "👩🏾‍🍳", "👮🏼‍♂️", "👩🏼‍🚒"],
                          ["🧠", "🫀", "👅", "🦷", "👄", "👂🏽", "🫁", "👁", "👃🏻"],
                          ["😓", "🥰", "🙄", "🥴", "🥳", "😇", "🧐", "🤩", "🤯"],
                          ["🧤", "👢", "👜", "🕶", "👛", "🧢", "👘", "🥼", "👚"],
                          ["🚕", "🚜", "🚑", "🚌", "🏎", "🏍", "🛴", "🚓", "🚒"]]
    
    var iconsLibrary = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var preGameTimer: Timer?
    var gameTimer : Timer?
    var roundTimer: Timer?
    var preGameTime = 3
    var gameTime = 0
    var roundTime = 0
    var points = 0
    var iconsShuffled: [String]?
    var isPlaying: Bool?
    let threeTop = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTime = initialGameTime
        isPlaying = false
        generateLibrary()
        icons.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        icons.delegate = self
        icons.dataSource = self
        startPreGameTimer()
    }
    
    
    // MARK: - Controlling the game functions

    public func startPreGameTimer(){
        preGameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(preGameCounter), userInfo: nil, repeats: true)
    }
    
    @objc func preGameCounter() {
        let animation = CATransition()
        animation.duration = 0.2
        targetIcon.layer.add(animation, forKey: nil)
        switch preGameTime {
        case 3:
            targetIcon.text = "3️⃣"
        case 2:
            targetIcon.text = "2️⃣"
        case 1:
            targetIcon.text = "1️⃣"
       default:
           setLabels()
           startGame()
           preGameTimer?.invalidate()
        }
        
        preGameTime -= 1
    }
    
    public func startGame(){
        isPlaying = true
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireGameTimer), userInfo: nil, repeats: true)
        roundTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireRoundTimer), userInfo: nil, repeats: true)
    }
    
    public func rebootGame() {
        preGameTime = 3
        roundTime = 0
        points = 0
        gameTime = initialGameTime
        generateLibrary()
        changesIconsOnScreen()
    }
    
    private func endGame(){
        isPlaying = false
        roundTimer?.invalidate()
        gameTimer?.invalidate()
        performSegue(withIdentifier: "showGameSummary", sender: nil)
//        presentAlert()
    }
    
    private func checkAnswer(selectedIcon: Int) {
        if isPlaying! {
            if targetIcon.text == iconsShuffled![selectedIcon] {
                rightAnswer()
                changesIconsOnScreen()
            } else {
                wrongAnswer()
                changesIconsOnScreen()
            }
        }
    }
    
    // MARK: - Controlling interface functions
    public func changesIconsOnScreen() {
        UIView.transition(with: icons, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.iconsShuffled = self.iconsLibrary.shuffled()
            self.icons.reloadData()
        }, completion: nil)
            
        let animation = CATransition()
        animation.duration = 0.2
        targetIcon.layer.add(animation, forKey: nil)
        targetIcon.text = generateRandomTarget()
    }
    
    private func generateLibrary() {
        iconsLibrary = iconsLibraries[Int.random(in: 0...iconsLibraries.count-1)]
        iconsShuffled = iconsLibrary.shuffled()
    }
    
    private func setLabels(){
        titleBar.backgroundColor = .systemYellow
        timeLabel.text = "\(gameTime) secs"
        pointsLabel.text = "0 pts"
        roundTimeLabel.text = ""
        targetIcon.text = generateRandomTarget()
    }
    
    /*
     Dentro de la función que indica si se ha acertado encontramos dos statements que utilizan librerías de terceros, el primero es Haptic, una libreria encontrada en CocoaPods que facilita la integración de vibraciones Hapticas, en el ejercicio se implementan para indicar al usuario si ha acertado o fallado en la respuesta.
     Igualmente, se usa Peep para indicarlo mediante sonido.
     
     El beneficio de CocoaPods es la importación, de manera sencilla, de librerías de terceros en los proyectos de XCode.
     
     Se ha integrado en este proyecto para facilitar el uso del motor haptico. 
     */
    private func rightAnswer() {
        let pointsToSum = (100 - roundTime)
        if pointsToSum > 0 {
            points += pointsToSum
        }
        titleBar.backgroundColor = .systemYellow
        pointsLabel.text = "\(points) pts"
        roundTimer?.invalidate()
        roundTime = 0
        roundTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireRoundTimer), userInfo: nil, repeats: true)
        Haptic.notification(.success).generate()
        Peep.play(sound: Bundle.main.url(forResource: "ok", withExtension: "m4a"))
    }
    
    private func wrongAnswer() {
        if points >= 100 {
            points -= 100
        } else {
            points = 0
        }
        pointsLabel.text = "\(points) pts"
        titleBar.backgroundColor = .red
        Haptic.notification(.error).generate()
        Peep.play(sound: Bundle.main.url(forResource: "error", withExtension: "m4a"))
    }
    
    // MARK: - Supporting functions
    private func generateRandomTarget()-> String {
        return iconsShuffled![Int.random(in: 0...iconsLibrary.count-1)]
    }
    
    /*
     Aunque los temporizadores se inician más arriba en este mismo archivo, aquí se presentan las funciones que ejecutan en cada iteración, por lo que hablaré aquí de ellos.
     Estos temporizadores o timers, se configuran como una variable más que se lanza con su función scheduledTimer en la cual se configura el tiempo que dura cada iteración, si se repiten cada iteración y la función a ejecutar. Esta tiene una notación especial ya que funcionan con Objetive C, el lenguaje de programación que se usaba anteriormente para el desarrollo en iOS.
     En el ejercicio se disponen dos temporizadores, uno para la partida y otro para la ronda, el primero controla la duración del juego y el segundo interviene en la puntuación, a mayor velocidad, mayor puntuación.
     */
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
    
    /*
     Gracias a los unwind segues se puede lanzar una función cuando se vuelve este viewcontroller desde cualquier otro. En este caso, no es necesario controlar desde cual se viene, ya que solo existe uno más.
     */
    @IBAction func unwindToGame(_ unwindSegue: UIStoryboardSegue) {
        Analytics.logEvent("RepeatPlay", parameters: ["message": "se ha vuelto a jugar"])
        startPreGameTimer()
        rebootGame()
        setLabels()
        targetIcon.text = "▶️"
    }
    
/*
 Las alertas son ventanas flotantes que presentan información al usurio y las cuales se pueden configurar con una serie de botones que llevan a cabo una función concreta.
 En este ejercicio se presentan al final de cada partida para mostrar los puntos obtenidos y ofrecer la posibilidad de jugar una nueva partida.
 
 La alternativa, que está implementada y comentada, era usar un nuevo viewController que presentará la información pero se ha desechado su uso por la complejidad a la hora de cerrarlo y reiniciar la partida, ya que este no era el objetivo principal del ejercicio.
 */
//    private func presentAlert(){
//        let finishAlert = UIAlertController(title: "Game Over", message: "You earned \(points) points!! \n Want to play again?", preferredStyle: .alert)
//        let playAgain = UIAlertAction(title: "Play", style: .default) { UIAlertAction in
//            self.rebootGame()
//            self.setLabels()
//            self.startGame()
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
//            self.dismiss(animated: true, completion: nil)
//        }
//        finishAlert.addAction(playAgain)
//        finishAlert.addAction(cancel)
//        self.present(finishAlert, animated: true, completion: nil)
//    }
    
}

/* Herramienta: CollectionView
 Las UICollectionView son una de las vistas más populares en el desarrollo de iOS. Mediante el uso de celdas reusables permite introducir una cantidad infinita de elementos en la vista que se colocarán en cuadrícula adaptandose al espacio disponible. Estas vistas permiten realizar scroll dentro de ellas, por lo que se le pueden introducir una cantidad ilimitada de elementos. Son perfectas para fotos y otros recursos cuya cantidad sea variable.
 
 Para hacerlas funcionar hay que extender la funcionalidad del viewcontroller para que incluyan el delegate y el datasource del collection view, de esta manera haremos al viewController el responsable de manejar los datos del collectionView. Para este ejercicio se han usado tres de sus funciones, la primera didSelectItemAt le indica al viewController que elemento (refiriendose al índice) del collectionView se ha pulsado. La segunda es numberOfItemsInSelection que indica el número de elementos que aparecen en la sección (si no se indica con su función correspondiente, el número por defecto es 1), por lo general, al ser algo variable se suele indicar con la función count de la colección que se quiera introducir, en este ejercicio se ha decidido que el número máximo serían 9 (el contenido de cada una de las librerias de emojis). La tercera función le indica al collectionView que llevará cada una de las celdas. Para el ejercicio se está usando una celda reusable configurada en un controlador y una vista a parte que se han registrado en la carga del viewController con el elemento de la librería correspondiente.
 
 La alternativa ha usar hubieran sido botones, pero se ha decidido usar las collectionView por la facilidad de configuración y adaptación a cualquier pantalla.
*/
// MARK: - Collection view extensions
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        checkAnswer(selectedIcon: indexPath[1])
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
