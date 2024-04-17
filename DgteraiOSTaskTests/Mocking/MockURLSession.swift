//
//  MockURLSession.swift
//  DgteraiOSTaskTests
//
//  Created by Ahmed Mahrous on 17/04/2024.
//

import Foundation
@testable import DgteraiOSTask

class MockURLSession: URLSessionProtocol {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}
