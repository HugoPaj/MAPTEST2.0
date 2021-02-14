//
//  LoginViewController.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 28.10.20.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        email.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    

    @IBAction func frgtpassTapped(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
                    DispatchQueue.main.async {
                        if self.email.text?.isEmpty==true || error != nil {
                            let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                            resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(resetFailedAlert, animated: true, completion: nil)
                        }
                        if error == nil && self.email.text?.isEmpty==false{
                            let resetEmailAlertSent = UIAlertController(title: "Reset Email Sent", message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: .alert)
                            resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(resetEmailAlertSent, animated: true, completion: nil)
                        }
                    }
                }
        
    }
    @IBAction func loginAction(_ sender: Any) {
          
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (result, error) in
       if error == nil{
         self.performSegue(withIdentifier: "loginToHome", sender: self)
                      }
        else{
         let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
          alertController.addAction(defaultAction)
          self.present(alertController, animated: true, completion: nil)
             }
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
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
