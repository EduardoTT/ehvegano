//
//  ContentController.swift
//  ehvegano
//
//  Created by Eduardo Tolmasquim on 21/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import Foundation

class ContentController: ObservableObject {
    
    //Exactly one of the variables has a value or is true. All the others are nil or false.
    @Published var product: Product?
    @Published var notFound = false
    @Published var errorMessage: String?
    @Published var isFetching = false
    
    func checkProduct(ean: String) {
        isFetching = true
        product = nil
        notFound = false
        errorMessage = nil
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
//            self.product = Product(id: "1234567890123", name: "oreo", type: .vegan)
//            self.notFound = true
            self.errorMessage = "falha no sistema"
            self.isFetching = false
        }
    }
}
