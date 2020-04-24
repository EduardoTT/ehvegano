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
        db = Firestore.firestore()
    }
    
    func getProduct(id: String, mockedData: [String:Any]? = nil, mockedError: Error? = nil, completion: @escaping (Result<Product?, NetworkError>) -> Void) {
        
        if mockedData != nil || mockedError != nil {
            parseGetProduct(id: id, completion: completion, data: mockedData, error: mockedError)
            return
        }
        
         db.collection("products").document(id).getDocument() { querySnapshot, error in
            self.parseGetProduct(
                id: id,
                completion: completion,
                data: querySnapshot?.data(),
                error:error
            )
        }
    }
    
    private func parseGetProduct(id: String, completion: @escaping (Result<Product?, NetworkError>) -> Void, data: [String:Any]?, error:Error?) {
        if let error = error {
            completion(.failure(.providerError(message: ("\(error)"))))
        } else {
            guard let dictionary = data else {
                completion(.success(nil))
                return
            }
            guard
                let name = dictionary["name"] as? String,
                let typeValue = dictionary["type"] as? Int,
                let type = Product.ProductType(rawValue: typeValue)
            else {
                completion(.success(nil))//parse error consider product as not found
                return
            }
            let product = Product(id: id, name: name, type: type)
            completion(.success(product))
        }
    }
    
    enum NetworkError: Error {
        case providerError(message: String)
    }
}

