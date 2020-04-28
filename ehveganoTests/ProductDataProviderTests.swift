//
//  ProductDataProviderTests.swift
//  ehveganoTests
//
//  Created by Eduardo Tolmasquim on 23/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import XCTest
@testable import ehvegano

final class ProductDataProviderTests: XCTestCase {

    private let provider = ProductDataProvider()
    private let id = "1234"
    let error = TestError.error

    func testGetProductNetworkError() {
        let someData = ["key": "value"]
        //The function should ignore the mockedData and return .failure
        provider.getProduct(id: id, mockedData: someData, mockedError: error) { result in
            switch result {
            case .success:
                XCTFail("The result should be an error")
            case .failure:
                break
            }
        }
    }
    
    func testGetProductParseError() {
        let missingTypeData = ["name": "produto"]
        //should return success, but product not found
        provider.getProduct(id: id, mockedData: missingTypeData, mockedError: nil) { result in
            switch result {
            case .success(let product):
                XCTAssertNil(product)
            case .failure:
                XCTFail("the result should be success and return a product")
            }
        }
    }
    
    func testGetProductNotFound() {
        let emptyData = [String: Any]()
        //should return success, but product not found
        provider.getProduct(id: id, mockedData: emptyData, mockedError: nil) { result in
            switch result {
            case .success(let product):
                XCTAssertNil(product)
            case .failure:
                XCTFail("the result should be success and return a product")
            }
        }
    }
    
    func testGetProductSuccess() {
        let data: [String: Any] = ["name": "my product", "type": 0]
        provider.getProduct(id: id, mockedData: data, mockedError: nil) { result in
            switch result {
            case .success(let product):
                XCTAssertNotNil(product)
            case .failure:
                XCTFail("the result should be success and return a product")
            }
        }
    }
    

    enum TestError: Error {
        case error
    }
}
