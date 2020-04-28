//
//  ContentControllerTests.swift
//  ehveganoTests
//
//  Created by Eduardo Tolmasquim on 23/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import XCTest
@testable import ehvegano

final class ContentControllerTests: XCTestCase {

    func testInitialState() {
        let dataProviderMock = ProductDataProviderMock(result: .success(nil))
        let controller = ContentController(provider: dataProviderMock)
        
        XCTAssertNil(controller.product)
        XCTAssertFalse(controller.notFound)
        XCTAssertFalse(controller.isFetching)
        XCTAssertNil(controller.errorMessage)
    }
    
    func testCheckProductIsFetching() {
        let dataProviderMockWithDelay = ProductDataProviderMockWithDelay()
        let controller = ContentController(provider: dataProviderMockWithDelay)
        controller.checkProduct(ean: "")
        
        XCTAssertNil(controller.product)
        XCTAssertFalse(controller.notFound)
        XCTAssertTrue(controller.isFetching)
        XCTAssertNil(controller.errorMessage)
    }
    
    func testCheckProductError() {
        let dataProviderMock = ProductDataProviderMock(result: .failure(.providerError(message: "some error")))
        let controller = ContentController(provider: dataProviderMock)
        controller.checkProduct(ean: "")
        
        XCTAssertNil(controller.product)
        XCTAssertFalse(controller.notFound)
        XCTAssertFalse(controller.isFetching)
        XCTAssertNotNil(controller.errorMessage)
    }
    
    func testCheckProductNotFound() {
        let dataProviderMock = ProductDataProviderMock(result: .success(nil))
        let controller = ContentController(provider: dataProviderMock)
        controller.checkProduct(ean: "")
        
        XCTAssertNil(controller.product)
        XCTAssertTrue(controller.notFound)
        XCTAssertFalse(controller.isFetching)
        XCTAssertNil(controller.errorMessage)
    }
    
    func testCheckProductSuccess() {
        let dataProviderMock = ProductDataProviderMock(result: .success(Product(id: "", name: "", type: .vegan)))
        let controller = ContentController(provider: dataProviderMock)
        controller.checkProduct(ean: "")
        
        XCTAssertNotNil(controller.product)
        XCTAssertFalse(controller.notFound)
        XCTAssertFalse(controller.isFetching)
        XCTAssertNil(controller.errorMessage)
    }

}

class ProductDataProviderMock: ProductDataProviderProtocol {
    
    var result: Result<Product?, ProductDataProvider.NetworkError>
    
    init(result: Result<Product?, ProductDataProvider.NetworkError>) {
        self.result = result
    }
    
    func getProduct(id: String, mockedData: [String: Any]? = nil, mockedError: Error? = nil, completion: @escaping (Result<Product?, ProductDataProvider.NetworkError>) -> Void) {
        completion(result)
    }
}

class ProductDataProviderMockWithDelay: ProductDataProviderProtocol {
    func getProduct(id: String, mockedData: [String: Any]?, mockedError: Error?, completion: @escaping (Result<Product?, ProductDataProvider.NetworkError>) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            completion(.success(nil))
        }
    }
}
