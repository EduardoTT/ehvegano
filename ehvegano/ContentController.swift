//
//  ContentController.swift
//  ehvegano
//
//  Created by Eduardo Tolmasquim on 21/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import Foundation

class ContentController: ObservableObject {
    
    //none or one of the variables has a value or is true. All the others are nil or false.
    @Published var product: Product?
    @Published var notFound = false
    @Published var errorMessage: String?
    @Published var isFetching = false
    
    private let provider: ProductDataProviderProtocol
    
    init(provider: ProductDataProviderProtocol? = nil) {
        self.provider = provider ?? ProductDataProvider()
    }
    
    func checkProduct(ean: String) {
        isFetching = true
        product = nil
        notFound = false
        errorMessage = nil
        provider.getProduct(id: ean) { result in
            self.isFetching = false
            switch result {
            case .success(let product):
                if let product = product {
                    self.product = product
                } else {
                    self.notFound = true
                }
            case .failure:
                self.errorMessage = "Ocorreu um erro, tente novamente"
            }
        }
    }
}
