//
//  StartViewController.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 28.10.20.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleMobileAds

class StartViewController: UIViewController {

    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
  
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        LoginButton.backgroundColor = .clear
        LoginButton.layer.cornerRadius = 20
        LoginButton.layer.borderWidth = 1
        LoginButton.layer.borderColor = UIColor.white.cgColor
        
        
        SignUpButton.layer.cornerRadius = 20
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
        
    override func viewDidAppear(_ animated: Bool){
    
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
         self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
       }
        
    }
    
    @IBAction func allLoggedInButton(_ sender: Any) {
      
        if Auth.auth().currentUser != nil {
        self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
       
        }
    

        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
