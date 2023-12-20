//
//  CocktailModel.swift
//  CocktailBook
//
//  Created by Nagaraju on 20/12/23.
//

import Foundation
struct CocktailElement: Codable,Hashable {
    let id, name: String
    let type: TypeEnum
    let shortDescription, longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
}

enum TypeEnum: String, Codable {
    case alcoholic = "alcoholic"
    case nonAlcoholic = "non-alcoholic"
}
