//
//  paymentGatewayController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 16/01/2023.
//

import UIKit
import StripePayments

class paymentGatewayController: UIViewController {

    func submitPayment(intent: STPPaymentIntentParams, completion: @escaping (STPPaymentHandlerActionStatus , STPPaymentIntent? ,NSError? ) -> Void){
        
        let paymentHandler = STPPaymentHandler.shared()
        
        paymentHandler.confirmPayment(intent, with: self) { status, intent, error in
            completion(status , intent , error)
        }
    }
    
    
    

    

}


extension paymentGatewayController : STPAuthenticationContext{
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
