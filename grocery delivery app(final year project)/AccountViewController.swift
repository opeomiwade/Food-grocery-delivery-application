//
//  AccountViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 19/02/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth
import Kommunicate


var pointsEarned: Int = 0
var accountDetails : [String] = []
class AccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: IBOUTLETS, IBACTIONS AND VARIABLES
    @IBOutlet weak var accountImage: UIImageView!
    
    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    let accountList = ["Account Details", "Orders" , "Help" , "Log Out"]
    
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        accountImage.layer.cornerRadius = accountImage.frame.size.width / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        Kommunicate.logoutUser(completion: <#T##(Result<String, KMError>) -> Void#>)
//        Kommunicate.
    }
    
    
    
    //MARK: TABLE VIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accountList.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AccountTableViewCell
        cell.label.text = accountList[indexPath.section]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(accountList[indexPath.section])
        if(accountList[indexPath.section] == "Help"){
            let kmUser = KMUser()
            let userId = currentUserInfo["userId"] as! String
            kmUser.userId = userId + randomString(length: 5)
            kmUser.email = currentUserInfo["email"] as? String
            
            Kommunicate.registerUser(kmUser) { response, error in
                if error == nil{
                    Kommunicate.createAndShowConversation(from: self) { error in
                        if error == nil {
                            print("success")
                        }
                        
                        else{
                            print(error!.localizedDescription)
                        }
                    }
                }
                
                print(" login Success ")
            }
            
            
            
        }
        
        else if(accountList[indexPath.section] == "Account Details"){
            performSegue(withIdentifier: "accounttodetails", sender: nil)
        }
        
        else if(accountList[indexPath.section] == "Orders"){
            performSegue(withIdentifier: "accounttoorders", sender: nil)
        }
        
        else if(accountList[indexPath.section] == "Log Out"){
            do{
                try Auth.auth().signOut()
            }
            
            catch let error as NSError{
                print(error.localizedDescription)
            }
            favoritePlaces = []
            favoriteDishes = []
            currentUserInfo = [:]
            performSegue(withIdentifier: "accounttoinitial", sender: nil)
            
        }
    }
    
    //MARK: VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("users").document(currentUserInfo["userId"] as! String).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            else{
                currentUserInfo = document!.data()!
                print("document succesfully read")
            }
        }
        
        if let points = currentUserInfo["points"] as? Int{
            pointsEarned = points
        }
        pointsLabel.text = "Points Earned: \(String(pointsEarned))"
        
        if let name = currentUserInfo["name"] as? String{
            nameLabel.text = name
        }
    }
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func unwindToaccountView(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    
}
