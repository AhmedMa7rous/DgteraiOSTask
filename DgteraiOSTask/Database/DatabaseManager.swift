//
//  DatabaseManager.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation
import SQLite

// MARK: - Database Manager
class DatabaseManager: DatabaseManagerProtocol {
    
    static let shared = DatabaseManager()
    
    private let db: Connection?
    private let productsTable = Table("products")
    
    private let id = Expression<Int>("id")
    private let displayName = Expression<String>("display_name")
    private let lstPrice = Expression<Int>("lst_price")
    private let imageSmall = Expression<String>("image_small")
    private let originalName = Expression<String>("original_name")
    private let nameAr = Expression<Bool>("name_ar")
    private let otherLangName = Expression<String>("other_lang_name")
    private let productVariantIDS = Expression<String>("product_variant_ids")
    private let sequence = Expression<Int>("sequence")
    private let quantity = Expression<Int>("quantity")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!

            db = try Connection("\(path)/products.sqlite3")
            createTable()
        } catch {
            db = nil
            print("Unable to open database")
        }
    }
    
    private func createTable() {
        do {
            try db?.run(productsTable.create { table in
                table.column(id, primaryKey: true)
                table.column(displayName)
                table.column(lstPrice)
                table.column(imageSmall)
                table.column(originalName)
                table.column(nameAr)
                table.column(otherLangName)
                table.column(productVariantIDS)
                table.column(sequence)
                table.column(quantity)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addProduct(product: Product) {
        do {
            let insert = productsTable.insert(
                id <- product.id,
                displayName <- product.displayName,
                lstPrice <- product.lstPrice,
                imageSmall <- imageSmallToString(product.imageSmall),
                originalName <- product.originalName,
                nameAr <- product.nameAr,
                otherLangName <- product.otherLangName,
                productVariantIDS <- product.productVariantIDS.map(String.init).joined(separator: ","),
                sequence <- product.sequence,
                quantity <- product.quantity
            )
            try db?.run(insert)
            print("Insert succedd")
        } catch {
            print("Insert failed")
        }
    }
    
    func getAllProducts() -> [Product] {
        var products: [Product] = []
        
        do {
            for product in try db!.prepare(productsTable) {
                let imageSmallValue = stringToImageSmall(product[imageSmall])
                let productVariantIDs = product[productVariantIDS].split(separator: ",").map { Int($0)! }
                
                let newProduct = Product(
                    id: product[id],
                    displayName: product[displayName],
                    lstPrice: product[lstPrice],
                    imageSmall: imageSmallValue,
                    originalName: product[originalName],
                    nameAr: product[nameAr],
                    otherLangName: product[otherLangName],
                    productVariantIDS: productVariantIDs,
                    sequence: product[sequence],
                    quantity: product[quantity]
                )
                
                products.append(newProduct)
            }
        } catch {
            print("Select failed")
        }
        
        return products
    }
    
    func deleteAllProducts() {
        do {
            try db?.run(productsTable.delete())
            print("Delete Succedd")
        } catch {
            print("Delete failed")
        }
    }
    
    private func imageSmallToString(_ imageSmall: ImageSmall) -> String {
        switch imageSmall {
        case .bool(let value):
            return "\(value)"
        case .string(let value):
            return value
        }
    }
    
    private func stringToImageSmall(_ string: String) -> ImageSmall {
        if let boolValue = Bool(string) {
            return .bool(boolValue)
        } else {
            return .string(string)
        }
    }
}
