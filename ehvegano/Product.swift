//
//  Product.swift
//  ehvegano
//
//  Created by Eduardo Tolmasquim on 21/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import Foundation

struct Product {
    var id: String
    var name: String
    var type: ProductType
    
    enum ProductType: Int {
        
        case vegan
        case notVegan
        case unknown
        
        var description: String {
            switch self {
            case .vegan: return "Vegano"
            case .notVegan: return "Não Vegano"
            case .unknown: return "Há dúvidas"
            }
        }
    }
}
