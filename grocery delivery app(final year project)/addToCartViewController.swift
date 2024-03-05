//
//  addToCartViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 13/01/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

var cart : [[String : String]] = []
var quantityArray : [[String : Int]] = []
class addToCartViewController: UIViewController {
    
    //MARK: VARIABLES AND OUTLETS
    @IBOutlet weak var addtocartbutton: UIButton!
    
    @IBOutlet weak var minusOutlet: UIButton!
    
    @IBOutlet weak var favButtonOutlet: UIButton!
    
    @IBAction func minusButton(_ sender: Any) {
        if(Int(amountLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == 2){
            minusOutlet.isEnabled = false
            let amount = Int(amountLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines))! - 1
            amountLabel.text! = String(amount)
        }
        
        else if(Int(amountLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines))! > 1){
            minusOutlet.isEnabled = true
            let amount = Int(amountLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines))! - 1
            amountLabel.text! = String(amount)
            
        }
    }
    

    @IBAction func plusButton(_ sender: Any) {
        let amount =  Int(amountLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines))! + 1
        amountLabel.text! = String(amount)
        minusOutlet.isEnabled = true
         
    }
    
    @IBOutlet weak var amountLabel: UILabel!
    
   
    @IBAction func addButton(_ sender: Any) {
        if(!cart.contains(itemDictionary)){
            cart.append(itemDictionary)
            quantityArray.append([itemDictionary["name"]! : Int(amountLabel.text!)!])
        }
        
        else if(cart.contains(itemDictionary)){
            var index = 0
            for item in cart{
                if(itemDictionary == item){
                    quantityArray[index].updateValue(quantityArray[index][cart[index]["name"]!]! + Int(amountLabel.text!)!, forKey: item["name"] ?? "")
                }
                index += 1
            }
        }
    }
    

    @IBAction func favButton(_ sender: Any) {
        if(!(favoriteDishes.contains(itemDictionary))){
            favButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteDishes.append(itemDictionary)
        }
        else{
            favButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteDishes = favoriteDishes.filter{$0 != itemDictionary}
        }

        let db = Firestore.firestore()
        db.collection("users").document(currentUserInfo["userId"] as! String).setData(["email" : currentUserInfo["email"]!, "name" : currentUserInfo["name"]!,"password" : currentUserInfo["password"]!,"postcode" : currentUserInfo["postcode"] ?? "nil" ,"userId" : currentUserInfo["userId"]!, "orders" : currentUserInfo["orders"] ?? "nil", "points" : pointsEarned, "favoritePlaces": favoritePlaces, "favoriteDishes": favoriteDishes ]){err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            }
            
            else {
                print("Document successfully written!")
            }
            
        }
        
    }
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var itemDictionary : [String : String] = ["" : ""]
    
    
    //MARK: VIEWWILLAPPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        if(favoriteDishes.contains(itemDictionary)){
            favButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        else{
            favButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10.0
        image.setImage(url: URL(string: itemDictionary["ImageUrl"] ?? " ")!)
        nameLabel.text = itemDictionary["name"]!
        descriptionLabel.text = itemDictionary["description"]!
    }
    
    
    
    
   
    
    
    
    
    
    
    

}
