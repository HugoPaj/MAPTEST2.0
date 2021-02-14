//
//  Utilities.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 03.02.21.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField){
        
        let bottomeLine = CALayer()
        
        bottomeLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomeLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomeLine)
        
    }
    
}
