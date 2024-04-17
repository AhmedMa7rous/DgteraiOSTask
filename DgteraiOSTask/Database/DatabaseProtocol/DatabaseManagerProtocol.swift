//
//  DatabaseManagerProtocol.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 17/04/2024.
//

import Foundation

protocol DatabaseManagerProtocol {
    func addProduct(product: Product)
    func getAllProducts() -> [Product]
    func deleteAllProducts()
}
