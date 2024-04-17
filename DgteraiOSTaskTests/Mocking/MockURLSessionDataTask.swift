//
//  MockURLSessionDataTask.swift
//  DgteraiOSTaskTests
//
//  Created by Ahmed Mahrous on 17/04/2024.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
