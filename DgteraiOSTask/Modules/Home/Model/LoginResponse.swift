//
//  LoginResponse.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let jsonrpc: String
    let id: Int
    let result: ResultData
}

// MARK: - Result
struct ResultData: Codable {
    let uid: Int
    let isSystem, isAdmin: Bool
    let userContext: UserContext
    let db, serverVersion: String
    let serverVersionInfo: [ServerVersionInfo]
    let name, username, partnerDisplayName: String
    let companyID, partnerID: Int
    let webBaseURL: String
    let activeIDSLimit, maxFileUploadSize: Int
    let userCompanies: UserCompanies
    let currencies: [String: Currency]
    let showEffect: String
    let displaySwitchCompanyMenu: Bool
    let cacheHashes: CacheHashes
    let userID: [Int]
    let maxTimeBetweenKeysInMS: Int
    let notificationType: String
    let odoobotInitialized, shEnableOneClick: Bool
    let userBrands: UserBrands
    let displaySwitchBrandMenu: Bool

    enum CodingKeys: String, CodingKey {
        case uid
        case isSystem = "is_system"
        case isAdmin = "is_admin"
        case userContext = "user_context"
        case db
        case serverVersion = "server_version"
        case serverVersionInfo = "server_version_info"
        case name, username
        case partnerDisplayName = "partner_display_name"
        case companyID = "company_id"
        case partnerID = "partner_id"
        case webBaseURL = "web.base.url"
        case activeIDSLimit = "active_ids_limit"
        case maxFileUploadSize = "max_file_upload_size"
        case userCompanies = "user_companies"
        case currencies
        case showEffect = "show_effect"
        case displaySwitchCompanyMenu = "display_switch_company_menu"
        case cacheHashes = "cache_hashes"
        case userID = "user_id"
        case maxTimeBetweenKeysInMS = "max_time_between_keys_in_ms"
        case notificationType = "notification_type"
        case odoobotInitialized = "odoobot_initialized"
        case shEnableOneClick = "sh_enable_one_click"
        case userBrands = "user_brands"
        case displaySwitchBrandMenu = "display_switch_brand_menu"
    }
}

// MARK: - CacheHashes
struct CacheHashes: Codable {
    let loadMenus, qweb, translations: String

    enum CodingKeys: String, CodingKey {
        case loadMenus = "load_menus"
        case qweb, translations
    }
}

// MARK: - Currency
struct Currency: Codable {
    let symbol, position: String
    let digits: [Int]
}

enum ServerVersionInfo: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ServerVersionInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ServerVersionInfo"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - UserBrands
struct UserBrands: Codable {
    let currentBrand: [Bool]

    enum CodingKeys: String, CodingKey {
        case currentBrand = "current_brand"
    }
}

// MARK: - UserCompanies
struct UserCompanies: Codable {
    let currentCompany: [ServerVersionInfo]
    let allowedCompanies: [[ServerVersionInfo]]

    enum CodingKeys: String, CodingKey {
        case currentCompany = "current_company"
        case allowedCompanies = "allowed_companies"
    }
}

// MARK: - UserContext
struct UserContext: Codable {
    let lang, tz: String
    let uid: Int
}
