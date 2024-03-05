//
//  SignUpViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 26/11/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameTextField: CustomTextFields!
    @IBOutlet weak var passwordTextField: CustomTextFields!
    @IBOutlet weak var emailTextField: CustomTextFields!
    @IBOutlet weak var postcodeTextField: CustomTextFields!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confrimPassworfField: CustomTextFields!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.customise()
        passwordTextField.customise()
        nameTextField.customise()
        postcodeTextField.customise()
        confrimPassworfField.customise()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if (validateuserInput() == false){
            validateuserInput()
        }
        
        else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let postcode = postcodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password){authResult,error in
                
                if error != nil{
                    self.errorLabel.text = error!.localizedDescription
                    print(error!.localizedDescription)
                }
                
                else{
                    let userData = InitialViewController.getUserInfo(authResult: authResult!)
                    let db = Firestore.firestore()
                    db.collection("users").document(userData.userId).setData(["email" : email, "password" : password, "userId" : authResult!.user.uid, "name" : name , "postcode" : postcode]){err in
                        if let err = err {
                            print("Error writing document: \(err.localizedDescription)")
                        }
                        
                        else {
                            print("Document successfully written!")
                        }
                        
                    }
                    
                    
                    let alert = UIAlertController(title:"Account has been created", message: "You can log in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert in
                        //segue to intial view of appplication
                        self.performSegue(withIdentifier: "returntoInitial", sender: nil)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
        //close keyboard after signup button is clicked
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    //MARK: VALIDATE USER INPUT
    func validateuserInput() -> Bool{
        //check user has provided necessary information by removing whitepsaces and newlines from text field and checking if it is empty
        var valid = true
        if(emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || postcodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "A field or all fields are empty", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            //print("both empty")
            valid = false
        }
        
        //check if password is secure enough for account
        let trimmedpassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmTrimmedPassword = confrimPassworfField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (passwordsMatch(trimmedpassword, confirmTrimmedPassword) == true) { // check passwords in fields match
            if isPasswordValid(trimmedpassword) == false{// chekc password strength
                let alert = UIAlertController(title: "Password isnt secure", message: "Make sure password is at least 8 characters,contains an alpahbet and a special character", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                present(alert, animated: true)
                valid = false
            }
            
            else{
                valid = true
            }
        }
        
        else{
            errorLabel.text = "Passwords do not match"
            valid = false
        }
        
        
        //ensure email is in correct format e.g ope@emailaddress.com or io@emailaddress.co.uk
        let trimmedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(isEmailValid(trimmedEmail) == false){
            let alert = UIAlertController(title: "Email is incorrect", message: "Make sure your email is in the correct format", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            //print("email invalid")
            valid = false
        }
        return valid
    }
    
    
    //MARK: Check password strength
    
    func isPasswordValid(_ password : String) -> Bool{
        /*
         Password validation criteria
         1 - Password length is 8.
         2 - One Alphabet in Password.
         3 - One Special Character in Password.
         
         
         Regex explained
         ^                                - Start Anchor.
         (?=.*[a-z])                 -Ensure string has one character.
         (?=.[$@$#!%?&])      -Ensure string has one special character.
         {8,}                            -Ensure password length is 8.
         $                                -End Anchor.
         */
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //MARK: check passwords in both firlds match
           func passwordsMatch(_ password1 : String, _ password2 : String) -> Bool{
        var boolean : Bool
        if(password1 == password2){
            boolean = true
        }
        else{
            boolean = false
        }
        return boolean
    }
    
    
    //MARK: check email is in ocrrect format
    
    func isEmailValid(_ email: String) -> Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        return emailTest.evaluate(with: email)
    }
    
    //MARK: TOUCHES BEGAN METHOD TO CLOSE KEYBOARD
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
}


extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
            
        else {
            textField.resignFirstResponder()
        }
        return false
    }
}
