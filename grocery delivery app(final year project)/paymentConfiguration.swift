//
//  paymentConfiguration.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 15/01/2023.
//

import Foundation

class PaymentConfig{
    var paymentIntent: String?
    static var shared : PaymentConfig = PaymentConfig()
    
    private init(){}
}
