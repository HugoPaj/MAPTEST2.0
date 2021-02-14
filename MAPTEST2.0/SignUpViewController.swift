//
//  SignUpViewController.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 28.10.20.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // setUpElements()
        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
        self.hideKeyboardWhenTappedAround() 

        // Do any additional setup after loading the view.
    }
    
    //func setUpElements() {
        
       // Utilities.styleTextField(firstnameTextField)
        //Utilities.styleTextField(lastnameTextField)
        //Utilities.styleTextField(email)
        //Utilities.styleTextField(password)
       // Utilities.styleTextField(passwordConfirm)
        
   // }
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBAction func signUpAction(_ sender: Any) {
    if password.text != passwordConfirm.text {
    let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
            }
    else{
        
        let firstname = firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = lastnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (result, error) in
     if error == nil {
     
        self.performSegue(withIdentifier: "signupToHome", sender: self)
        db.collection("users").addDocument(data: ["firstname":firstname,"lastname":lastname, "uid": result!.user.uid]) { (error) in
           
        }
        
        
                    }
     
     else{
       let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
           }
                }
          }
    }
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

