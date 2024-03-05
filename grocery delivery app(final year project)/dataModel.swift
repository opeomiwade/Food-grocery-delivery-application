//
//  dataModel.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 08/01/2023.
//

import Foundation

struct restaurant: Decodable{
    let objectId: String
    let restaurant: String
    let name: String
    let description: String
    let calories: String
    let price: String
    let ImageUrl: String
    let type: String
    let category: String
    let createdAt: String
    let updatedAt: String
}

struct restaurants: Decodable{
    let results : [restaurant]
}
