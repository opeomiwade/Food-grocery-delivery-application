//
//  AccountDetailsViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 13/03/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountDetailsViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        nameTextField.text =  currentUserInfo["name"] as? String
        
        if(currentUserInfo["postcode"] as! String != "nil"){
            postcodeTextField.text = currentUserInfo["postcode"] as? String
        }
        
        else{
            postcodeTextField.text = "L1 2QW"
        }
        
        emailTextField.text = currentUserInfo["email"] as? String
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var postcodeTextField: UITextField!
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Your account will be deleted,Are you sure?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            let user = Auth.auth().currentUser
            user?.delete{ error in
                if error == nil{
                    print("account deleted")
                    let db = Firestore.firestore()
                    let reference = db.collection("users").document(currentUserInfo["userId"] as! String)
                    reference.delete { error in
                        if error == nil{
                            print("document deleted")
                        }
                        
                        else{
                            print(error!.localizedDescription)
                        }
                    }
                    self.performSegue(withIdentifier: "deletedaccount", sender: nil)
                    
                    
                }
                
                else{
                    print(error!.localizedDescription)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
       
        
    }
    
    
}
