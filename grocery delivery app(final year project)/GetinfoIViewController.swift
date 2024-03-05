//
//  GetinfoIViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 01/12/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GetinfoIViewController: UIViewController {
    
    //MARK: OUTLETS, ACTIONS and VARIABLES
    
    var email: String?
    var userID : String?
    var name : String?
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var postcodeText: UITextField!
    
    
    @IBAction func continueButton(_ sender: Any) {
        if (emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""  && postcodeText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            performSegue(withIdentifier: "infotohome", sender: nil)
        }
        
        else{
            let alert = UIAlertController(title: "Fill in all fields before proceeding", message: "" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
        
        
    }
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        emailText.customise()
        postcodeText.customise()
        if let email = email{
            emailText.text = email
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: VIEWILLAPPEAR
    
    
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        print(userID ?? "")
        db.collection("users").document((userID!)).getDocument(completion: { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            else{
                //print(document)
                if document!.exists{
                    currentUserInfo = (document!.data()!)
                }
               
                if let places = currentUserInfo["favoritePlaces"] as? [String]{
                    favoritePlaces = places
                    print(favoritePlaces)
                }
                
                if let dishes = currentUserInfo["favoriteeDishes"] as? [[String : String]]{
                    favoriteDishes = dishes
                    print(favoriteDishes)
                }
            }
            
        })
    }
    
    
    //MARK: PREPARE FOR SEGUE METHOD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "infotohome"){
            if let barVC = segue.destination as? UITabBarController {
                barVC.viewControllers?.forEach {
                    if let vc = $0 as? HomeViewController {
                        vc.postCode = postcodeText.text!
                        vc.id = userID!
                    }
                }
            }
        }
    }
    
    //MARK: TOUCHES BEGAN METHOD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        email = emailText.text
      
    }
}



extension GetinfoIViewController: UITextFieldDelegate{
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
