//
//  LoginRequestBody.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation

struct LoginRequestBody: Encodable {
    let jsonrpc: String
    let method: String
    let id: Int
    let params: LoginParams
    
    struct LoginParams: Encodable {
        let login: String
        let password: String
        let db: String
        let context: Context
        
        struct Context: Encodable {
            let display_default_code: Bool
            let tz: String
            let false_name_ar: Bool
            let uid: Int
            let lang: String
        }
    }
}
