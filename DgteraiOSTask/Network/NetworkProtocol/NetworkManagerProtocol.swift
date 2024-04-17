//
//  NetworkManagerProtocol.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation

protocol NetworkManagerProtocols {
    func login(completion: @escaping (Result<LoginResponse, APIError>) -> Void)
    func fetchProducts(for authUser: LoginResponse, completion: @escaping (Result<Products, APIError>) -> Void)
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
