//
//  CardModel.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 24.01.21.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array to store numbers
        var generateNumbersArray = [Int]()
        
        // Declare an array to store the generate cards
        var generatedCardArray = [Card]()
        
        // Randomly generate pairs of cards
        while generateNumbersArray.count < 8 {
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            //Ensure that the random number we have isn't one we already have
            if generateNumbersArray.contains(Int(randomNumber)) == false {
                
                // Log the number
                print(randomNumber)
                
                // Store the number into the generateNumbersArrat
                generateNumbersArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardArray.append(cardOne)
                
                // Create the second card ibject
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardArray.append(cardTwo)
                
            }
            
            
        }
        
        // Randomize the array
        
        for i in 0...generatedCardArray.count-1 {
            
            // Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardArray.count)))
            
            // Swap the two cards
            let temporaryStorage = generatedCardArray[i]
            generatedCardArray[i] = generatedCardArray[randomNumber]
            generatedCardArray[randomNumber] = temporaryStorage
        }
        // Return the array
        return generatedCardArray
        
    }
    
}
