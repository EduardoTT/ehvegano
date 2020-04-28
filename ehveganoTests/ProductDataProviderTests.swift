//
//  ProductDataProviderTests.swift
//  ehveganoTests
//
//  Created by Eduardo Tolmasquim on 23/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import XCTest
@testable import ehvegano

private final class ProductDataProviderTests: XCTestCase {

    private let provider = ProductDataProvider()
    private let id = "1234"
    let error = TestError.error
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetProductNetworkError() {
        let someData = ["key":"value"]
        //The function should ignore the mockedData and return .failure
        provider.getProduct(id: id, mockedData: someData, mockedError: error) { result in
            switch result {
            case .success: XCTFail()
            case .failure: break
            }
        }
    }
    
    func testGetProductParseError() {
        let missingTypeData = ["name":"produto"]
        //should return success, but product not found
        provider.getProduct(id: id, mockedData: missingTypeData, mockedError: nil) { result in
            switch result {
            case .success(let product):
                XCTAssertNil(product)
            case .failure: XCTFail()
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
            case .failure: XCTFail()
            }
        }
    }
    
    func testGetProductSuccess() {
        let data: [String:Any] = ["name":"my product", "type":0]
        provider.getProduct(id: id, mockedData: data, mockedError: nil) { result in
            switch result {
            case .success(let product):
                XCTAssertNotNil(product)
            case .failure: XCTFail()
            }
        }
    }
    

    enum TestError: Error {
        case error
    }
}
