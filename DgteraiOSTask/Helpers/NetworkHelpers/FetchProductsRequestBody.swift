//
//  FetchProductsRequestBody.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation


struct FetchProductsRequestBody: Codable {
    let params: ProductParams
    let jsonrpc: String
    let method: String
    let id: Int

    struct ProductParams: Codable {
        let model: String
        let args: [String]
        let kwargs: KWargs
        let offset: Int
        let context: Context
        let fields: [String]
        let limit: Bool
        let method: String
    }

    struct KWargs: Codable {
        let domain: [[String]]
        let offset: Int
        let context: Context
        let fields: [String]
        let limit: Bool
    }

    struct Context: Codable {
        let display_default_code: Bool
        let tz: String
        let false_name_ar: Bool
        let uid: Int
        let lang: String
    }
}
