//
//  DgteraiOSTaskTests.swift
//  DgteraiOSTaskTests
//
//  Created by Ahmed Mahrous on 17/04/2024.
//

import XCTest
import SQLite
@testable import DgteraiOSTask

final class DatabaseManagerTests: XCTestCase {
    
    var databaseManager: DatabaseManager!
    
    override func setUpWithError() throws {
        databaseManager = DatabaseManager.shared
        databaseManager.deleteAllProducts()
    }
    
    override func tearDownWithError() throws {
        databaseManager.deleteAllProducts()
        databaseManager = nil
        
        try super.tearDownWithError()
    }
    
    func testAddProduct() throws {
        // Given
        let product = Product(
            id: 1,
            displayName: "Test Product",
            lstPrice: 100,
            imageSmall: .string("imageData"),
            originalName: "Original Name",
            nameAr: true,
            otherLangName: "Other Lang Name",
            productVariantIDS: [1, 2],
            sequence: 1,
            quantity: 1
        )
        
        // When
        databaseManager.addProduct(product: product)
        
        // Then
        let products = databaseManager.getAllProducts()
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.id, 1)
    }
    
    func testGetAllProducts() throws {
        // Given
        let product1 = Product(
            id: 1,
            displayName: "Product 1",
            lstPrice: 100,
            imageSmall: .string("imageData1"),
            originalName: "Original Name 1",
            nameAr: true,
            otherLangName: "Other Lang Name 1",
            productVariantIDS: [1],
            sequence: 1,
            quantity: 1
        )
        
        let product2 = Product(
            id: 2,
            displayName: "Product 2",
            lstPrice: 200,
            imageSmall: .string("imageData2"),
            originalName: "Original Name 2",
            nameAr: false,
            otherLangName: "Other Lang Name 2",
            productVariantIDS: [2],
            sequence: 2,
            quantity: 2
        )
        
        databaseManager.addProduct(product: product1)
        databaseManager.addProduct(product: product2)
        
        // When
        let products = databaseManager.getAllProducts()
        
        // Then
        XCTAssertEqual(products.count, 2)
        XCTAssertEqual(products.first?.id, 1)
        XCTAssertEqual(products.last?.id, 2)
    }
    
    func testDeleteAllProducts() throws {
        // Given
        let product = Product(
            id: 1,
            displayName: "Test Product",
            lstPrice: 100,
            imageSmall: .string("imageData"),
            originalName: "Original Name",
            nameAr: true,
            otherLangName: "Other Lang Name",
            productVariantIDS: [1],
            sequence: 1,
            quantity: 1
        )
        
        databaseManager.addProduct(product: product)
        
        // When
        databaseManager.deleteAllProducts()
        
        // Then
        let products = databaseManager.getAllProducts()
        XCTAssertEqual(products.count, 0)
    }
}
