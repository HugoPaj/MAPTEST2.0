//
//  WelcomeBackViewController.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 11.01.21.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var memoryGamesLabel: UILabel!
    @IBOutlet weak var bImage: UIImageView!
    @IBOutlet weak var popupButton: UIButton!
    
    @IBAction func clearUp(_ sender: Any) {
       
        memoryGamesLabel.alpha = 0
        bImage.alpha = 0
        popupButton.alpha = 0
        
    }
    
    
    @IBAction func startButton(_ sender: Any) {
        
        timerLabel.textColor = UIColor.white
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)

        
    }
    
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 60 * 1000
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
      //  timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
      //  RunLoop.main.add(timer!, forMode: .common)

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        //SoundManager.playSound(.shuffle)
        
    }
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
        if milliseconds <= 0 {
            
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            checkGameEnded()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as!
            CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
        cell.flip()
            
            //SoundManager.playSound(.flip)
        
        card.isFlipped = true
            
            if firstFlippedCardIndex == nil{
               
                firstFlippedCardIndex = indexPath
            }
            else{
                
                checkForMatches(indexPath)
                
            }
        }
        
    }
    

    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
    
        if cardOne.imageName == cardTwo.imageName {
            
            //SoundManager.playSound(.match)
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkGameEnded()
            
        }
        else {
            
            //SoundManager.playSound(.nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        if cardOneCell == nil {
            
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
            
        }
        
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        
        var isWon = true
        
        for card in cardArray{
            
            if card.isMatched == false{
            isWon = false
            break
                
            }
        }
        
        var title = ""
        var message = ""
    
    if isWon == true  {
    
        if milliseconds > 0 {
            timer?.invalidate()
            
        }
        
        title = "Congratulations"
        message = "You've Won"
    
    }
        else {
    
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        
        }
        
        showAlert(title, message)
 
    }
    
    func showAlert(_ title:String, _ message:String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Continue", style: .default) { (restart) in
            self.restart()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
  
    func restart() {
          cardArray = [Card]()
          cardArray = model.getCards()
          milliseconds = 60 * 1000
          collectionView.reloadData()
        
      }
    
    @IBAction func LogOutAction(_ sender: Any) {
        
        do {
                    try Auth.auth().signOut()
                }
             catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initial = storyboard.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = initial
        
         }
        
    }
    

