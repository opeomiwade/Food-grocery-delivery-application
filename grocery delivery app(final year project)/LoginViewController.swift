//
//  LoginViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 22/11/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

var currentUserInfo : [String : Any] = [:]
var providerName = ""
class LoginViewController: UIViewController {
    
    
 //MARK: IBOUTLETS,VARIABLES AND IBACTIONS
    
    var userID = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(_ sender: Any) {
        if(emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "A field or all fields are empty", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
        
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email!, password: password!){ [self] user, error in
            if error != nil{
                let error = error!.localizedDescription
                print(error)
                if error == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    let alert = UIAlertController(title: error, message: "Would you like to a create user?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "logintosignup", sender: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                        let alert = UIAlertController(title: "You cannot log in ", message: "You must go back and create an account", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.performSegue(withIdentifier: "backtoinitial", sender: nil)
                        }))
                        self.present(alert, animated: true)
                    }))
                    self.present(alert, animated: true)
                }
                
                else if(error == "The password is invalid or the user does not have a password." ){
                    let alert = UIAlertController(title: "Invalid passowrd", message: "You have entered the wrong password for this account", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default))
                    alert.addAction(UIAlertAction(title: "Forgot Password?", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "logintoforgotpassword", sender: nil)
                    }))
                    self.present(alert, animated: true)
                }
                
                else if(error == "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."){
                    
                    let alert = UIAlertController(title: error, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Reset Password", style:.default, handler: { action in
                        self.performSegue(withIdentifier: "logintoforgotpassword", sender: nil)
                    }))
                    self.present(alert, animated: true)
                }
                
                else{
                    let alert = UIAlertController(title: error, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            }
            
            else{
                providerName = "firebase"
                let db = Firestore.firestore()
                userID = user!.user.uid
                print(userID)
                db.collection("users").document((user!.user.uid)).getDocument(completion: { (document, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    else{
                        currentUserInfo = (document?.data()!)!
                        print(currentUserInfo)
                        if let places = currentUserInfo["favoritePlaces"] as? [String]{
                            favoritePlaces = places
                            print(favoritePlaces)
                        }
                       
                        if let dishes = currentUserInfo["favoriteDishes"] as? [[String : String]]{
                            favoriteDishes = dishes
                            print(favoriteDishes)
                        }
                    }
                
                })
                print(currentUserInfo)
                self.performSegue(withIdentifier: "fromlogintohome", sender: nil)
            }
        }
        
        
    }
    
    //MARK: PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromlogintohome"{
            if let barVC = segue.destination as? UITabBarController{
                barVC.viewControllers?.forEach{
                    if let vc = $0 as? HomeViewController{
                        vc.id = self.userID
                    }
                }
            }
        }
    }
    
    //MARK: VIEWDIDLOAD,VIEWDIDDISAPPEAR
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.customise()
        passwordTextField.customise()
        emailTextField.fieldImage(image: UIImage(systemName: "envelope")!)
        passwordTextField.fieldImage(image: UIImage(systemName: "lock")!)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
}

//MARK: EXTENSIONS
extension UITextField {
    func customise(){
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 1)
        layer.backgroundColor = UIColor.red.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(layer)
    }
    
    func fieldImage(image : UIImage){
        self.leftViewMode = .always
        let leftView = UIImageView(frame: CGRect(x: 0, y: self.frame.height/2 - 10, width: 25, height: 20))
        leftView.tintColor = .black
        leftView.image = image
        self.addSubview(leftView)
    }
}

extension LoginViewController: UITextFieldDelegate{
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


    
