//
//  ProductDataProvider.swift
//  ehvegano
//
//  Created by Eduardo Tolmasquim on 21/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import Foundation
import Firebase

class ProductDataProvider {

    private let db: Firestore
    
    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    func getProduct(id: String, completion: @escaping (Result<Product?, NetworkError>) -> Void) {
        db.collection("products").document(id).getDocument { querySnapshot, error in
            if let error = error {
                completion(.failure(.providerError(message: ("\(error)"))))
            } else {
                guard let dictionary = querySnapshot!.data() else {
                    completion(.success(nil))
                    return
                }
                guard
                    let name = dictionary["name"] as? String,
                    let typeValue = dictionary["type"] as? Int,
                    let type = Product.ProductType(rawValue: typeValue)
                else {
                    completion(.failure(.parseError(message: ("Erro no parse"))))
                    return
                }
                let product = Product(id: id, name: name, type: type)
                completion(.success(product))
            }
        }
    }
    
    enum NetworkError: Error {
        case providerError(message: String)
        case parseError(message: String)
    }
}

