//
//  NetworkManagerTests.swift
//  DgteraiOSTaskTests
//
//  Created by Ahmed Mahrous on 17/04/2024.
//

import XCTest
@testable import DgteraiOSTask

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        networkManager = NetworkManager.shared
        networkManager.session = mockSession
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        mockSession = nil
        
        try super.tearDownWithError()
    }
    
    func testLoginSuccess() throws {
        // Given
        let loginResponse = LoginResponse(jsonrpc: "2.0", id: 1, result: ResultData(uid: 1, isSystem: true, isAdmin: false, userContext: UserContext(lang: "en", tz: "UTC", uid: 1), db: "testDB", serverVersion: "14.0", serverVersionInfo: [.integer(14)], name: "Test User", username: "testuser", partnerDisplayName: "Test Partner", companyID: 1, partnerID: 1, webBaseURL: "http://example.com", activeIDSLimit: 5, maxFileUploadSize: 1024, userCompanies: UserCompanies(currentCompany: [.integer(1)], allowedCompanies: [[.integer(1)]]), currencies: ["USD": Currency(symbol: "$", position: "after", digits: [2])], showEffect: "no_effect", displaySwitchCompanyMenu: true, cacheHashes: CacheHashes(loadMenus: "hash1", qweb: "hash2", translations: "hash3"), userID: [1], maxTimeBetweenKeysInMS: 1000, notificationType: "inbox", odoobotInitialized: false, shEnableOneClick: true, userBrands: UserBrands(currentBrand: [true]), displaySwitchBrandMenu: false))
        
        let loginResponseData = try JSONEncoder().encode(loginResponse)
        mockSession.data = loginResponseData
        mockSession.response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        var capturedResult: Result<LoginResponse, APIError>?
        
        // When
        networkManager.login { result in
            capturedResult = result
        }
        
        // Then
        switch capturedResult {
        case .success(let response):
            XCTAssertEqual(response.result.uid, 1) // Expecting uid to be 1
            XCTAssertEqual(response.result.name, "Test User")
        case .failure(_):
            XCTFail("Expected success, but got failure")
        case .none:
            XCTFail("Expected success, but got nil")
        }
    }

    func testLoginFailure() throws {
        // Given
        mockSession.error = NSError(domain: "Test", code: 1234, userInfo: nil)
        
        var capturedResult: Result<LoginResponse, APIError>?
        
        // When
        networkManager.login { result in
            capturedResult = result
        }
        
        // Then
        switch capturedResult {
        case .success(_):
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error, .requestFailed(mockSession.error!))
        case .none:
            XCTFail("Expected failure, but got nil")
        }
    }
    
    func testFetchProductsSuccess() throws {
        // Given
        let productsResponse = Products(jsonrpc: "2.0", id: 1, result: [
            Product(id: 1, displayName: "Product1", lstPrice: 100, imageSmall: .string("base64string1"), originalName: "OriginalName1", nameAr: true, otherLangName: "OtherLangName1", productVariantIDS: [1, 2], sequence: 1),
            Product(id: 2, displayName: "Product2", lstPrice: 200, imageSmall: .string("base64string2"), originalName: "OriginalName2", nameAr: false, otherLangName: "OtherLangName2", productVariantIDS: [3, 4], sequence: 2)
        ])
        
        let productsResponseData = try JSONEncoder().encode(productsResponse)
        mockSession.data = productsResponseData
        mockSession.response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // Create a mock LoginResponse to use for fetchProducts
        let mockLoginResponse = LoginResponse(jsonrpc: "2.0", id: 1, result: ResultData(uid: 1, isSystem: true, isAdmin: false, userContext: UserContext(lang: "en", tz: "UTC", uid: 1), db: "testDB", serverVersion: "14.0", serverVersionInfo: [.integer(14)], name: "Test User", username: "testuser", partnerDisplayName: "Test Partner", companyID: 1, partnerID: 1, webBaseURL: "http://example.com", activeIDSLimit: 5, maxFileUploadSize: 1024, userCompanies: UserCompanies(currentCompany: [.integer(1)], allowedCompanies: [[.integer(1)]]), currencies: ["USD": Currency(symbol: "$", position: "after", digits: [2])], showEffect: "no_effect", displaySwitchCompanyMenu: true, cacheHashes: CacheHashes(loadMenus: "hash1", qweb: "hash2", translations: "hash3"), userID: [1], maxTimeBetweenKeysInMS: 1000, notificationType: "inbox", odoobotInitialized: false, shEnableOneClick: true, userBrands: UserBrands(currentBrand: [true]), displaySwitchBrandMenu: false))
        
        var capturedResult: Result<Products, APIError>?
        
        // When
        networkManager.fetchProducts(for: mockLoginResponse) { result in
            capturedResult = result
        }
        
        // Then
        switch capturedResult {
        case .success(let response):
            XCTAssertEqual(response.result.count, 2) // Expecting 2 products in the result
            XCTAssertEqual(response.result[0].displayName, "Product1")
            XCTAssertEqual(response.result[1].lstPrice, 200)
        case .failure(_):
            XCTFail("Expected success, but got failure")
        case .none:
            XCTFail("Expected success, but got nil")
        }
    }
    
    func testFetchProductsFailure() throws {
        // Given
        let mockLoginResponse = LoginResponse(jsonrpc: "2.0", id: 1, result: ResultData(uid: 1, isSystem: true, isAdmin: false, userContext: UserContext(lang: "en", tz: "UTC", uid: 1), db: "testDB", serverVersion: "14.0", serverVersionInfo: [.integer(14)], name: "Test User", username: "testuser", partnerDisplayName: "Test Partner", companyID: 1, partnerID: 1, webBaseURL: "http://example.com", activeIDSLimit: 5, maxFileUploadSize: 1024, userCompanies: UserCompanies(currentCompany: [.integer(1)], allowedCompanies: [[.integer(1)]]), currencies: ["USD": Currency(symbol: "$", position: "after", digits: [2])], showEffect: "no_effect", displaySwitchCompanyMenu: true, cacheHashes: CacheHashes(loadMenus: "hash1", qweb: "hash2", translations: "hash3"), userID: [1], maxTimeBetweenKeysInMS: 1000, notificationType: "inbox", odoobotInitialized: false, shEnableOneClick: true, userBrands: UserBrands(currentBrand: [true]), displaySwitchBrandMenu: false))
        
        mockSession.error = NSError(domain: "Test", code: 1234, userInfo: nil)
        
        var capturedResult: Result<Products, APIError>?
        
        // When
        networkManager.fetchProducts(for: mockLoginResponse) { result in
            capturedResult = result
        }
        
        // Then
        switch capturedResult {
        case .success(_):
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error, .requestFailed(mockSession.error!))
        case .none:
            XCTFail("Expected failure, but got nil")
        }
    }
}
