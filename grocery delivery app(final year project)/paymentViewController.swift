//
//  paymentViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 15/01/2023.
//

import UIKit
import StripePaymentsUI
import FirebaseCore
import FirebaseFirestore


class paymentViewController: UIViewController {
    
    //MARK: IBOUTLETS, IBACTIONS AND VARIABLES
    @IBOutlet weak var cardNumber: STPPaymentCardTextField!
    
    @IBOutlet weak var payOutlet: UIButton!
    let paymentsGatewayController = paymentGatewayController()
    
    @IBOutlet weak var priceLabel: UILabel!
    var price : [Double] = []
    
    
    @IBAction func payButtonTapped(_ sender: Any) {
        guard let secretKey = PaymentConfig.shared.paymentIntent else {
            return
        }
        
        let paymentParameters = STPPaymentIntentParams(clientSecret: secretKey)
        paymentParameters.paymentMethodParams = cardNumber.paymentMethodParams
        
        paymentsGatewayController.submitPayment(intent: paymentParameters) { status, intent , error in
            switch(status){
            case .failed:
                print("failed")
                
            case .succeeded:
                print("succeeded")
                let alert = UIAlertController(title: "Payment successful", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: { action in
                    CartViewController.fromPayment = true
                    quantityArray = []
                    print(pointsEarned)
                    pointsEarned += Int(self.price[0])
                    print(pointsEarned)
                    let db = Firestore.firestore()
                    if let orderArray = currentUserInfo["orders"] as? NSArray{
                        for item in orderArray{
                            print(item)
                            cart.append(item as! [String : String])
                        }
                    }
                    
                    print(cart)
                    db.collection("users").document(currentUserInfo["userId"] as! String).setData(["email" : currentUserInfo["email"]!, "name" : currentUserInfo["name"]!,"password" : currentUserInfo["password"]!,"postcode" : currentUserInfo["postcode"] ?? "nil" ,"userId" : currentUserInfo["userId"]!, "orders" : cart, "points" : pointsEarned, "favoritePlaces" : currentUserInfo["favoritePlaces"] ?? "nil", "favoriteDishes" : currentUserInfo["favoriteDishes"] ?? "nil"])
                    cart = []
                    self.performSegue(withIdentifier: "backtocart", sender: nil)
                }))
                self.present(alert , animated: true)
                
            case .canceled:
                print("cancelled")
            }
        }
        
        
        
    }
    
    
    //MARK: VIEWDIDLOAD, VIEWWILLDISAAPEAR,VIEWILLAPPEAR
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        priceLabel.text = "£\(String(price[0]/100))0"
    }
    
    
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
    }
    
    
    
    
    
    
    
    
    
}

