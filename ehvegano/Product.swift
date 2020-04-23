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
    
    enum ProductType: String, CustomStringConvertible {
        
        var description: String {
            return self.rawValue
        }
        
        case vegan = "vegan"
        case notVegan = "notVegan"
        case unknown = "unknown"
    }
}
