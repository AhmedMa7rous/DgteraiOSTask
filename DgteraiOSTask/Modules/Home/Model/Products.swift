//
//  Products.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation

// MARK: - Products
struct Products: Codable {
    let jsonrpc: String
    let id: Int
    let result: [Product]
    
    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case id
        case result
    }
}

// MARK: - Result
struct Product: Codable {
    let id: Int
    let displayName: String
    let lstPrice: Int
    let imageSmall: ImageSmall
    let originalName: String
    let nameAr: Bool
    let otherLangName: String
    let productVariantIDS: [Int]
    let sequence: Int

    var quantity: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case lstPrice = "lst_price"
        case imageSmall = "image_small"
        case originalName = "original_name"
        case nameAr = "name_ar"
        case otherLangName = "other_lang_name"
        case productVariantIDS = "product_variant_ids"
        case sequence
    }
}

enum ImageSmall: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ImageSmall.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ImageSmall"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
