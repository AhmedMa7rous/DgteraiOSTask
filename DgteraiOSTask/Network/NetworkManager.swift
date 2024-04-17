//
//  NetworkManager.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation

class NetworkManager: NetworkManagerProtocols {
    //MARK: - Properties
    static let shared = NetworkManager()
    var session: URLSessionProtocol
    //MARK: - LifeCycle
    private init() { 
        session = URLSession.shared
    }
   
    //MARK: - Support Functions
    
    ///makeRequest is a generic function for making API requests
    private func makeRequest<T: Decodable, U: Encodable>(urlString: String, method: String, requestBody: U, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = createURL(from: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch let error {
            print(error.localizedDescription)
            completion(.failure(.encodingFailed))
            return
        }
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.decodeData(data: data, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    ///createURL  responsible for creating the url with it's body or params for the requests
    private func createURL(from urlString: String) -> URL? {
        let urlStringWithParams = Constants.baseURL + urlString
        return URL(string: urlStringWithParams)
    }
    
    ///decodeData  responsible for decoding the data
    private func decodeData<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, APIError>) -> Void) {
        
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        guard let data = data else {
            completion(.failure(.invalidResponse))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(.decodingFailed))
        }
    }
    
    private func createLoginRequestBody() -> LoginRequestBody {
        return LoginRequestBody(
                jsonrpc: "2.0",
                method: "call",
                id: 1,
                params: .init(
                    login: "api_key_client_1",
                    password: "9M2CstCBMrL_GA969gRvQgDiGWOivR7ht-znSr_ZqvOJjmEJaFyrrJF3cDvTtZQvMPTo8flglEcQR_9Od1onzg",
                    db: "comu_test_tomtom",
                    context: .init(
                        display_default_code: false,
                        tz: "Asia/Riyadh",
                        false_name_ar: true,
                        uid: 6,
                        lang: "ar_001"
                    )
                )
            )
    }
    
    private func createFetchProductsRequestBody(for user: LoginResponse) -> FetchProductsRequestBody {
        let context = user.result.userContext
            
            let kwargs = FetchProductsRequestBody.KWargs(
                domain: [
                    ["active", "=", "true"],
                    ["invisible_in_ui", "=", "true"],
                    ["is_combo", "=", "false"],
                    ["sale_ok", "=", "true"],
                    ["available_in_pos", "=", "true"],
                    ["active", "=", "true"]
                ],
                offset: 0,
                context: FetchProductsRequestBody.Context(
                    display_default_code: false,
                    tz: context.tz,
                    false_name_ar: true,
                    uid: context.uid,
                    lang: context.lang
                ),
                fields: [
                    "id",
                    "display_name",
                    "lst_price",
                    "image_small",
                    "original_name",
                    "name_ar",
                    "other_lang_name",
                    "product_variant_ids",
                    "sequence"
                ],
                limit: false
            )
            
            return FetchProductsRequestBody(
                params: .init(
                    model: "product.product",
                    args: [],
                    kwargs: kwargs,
                    offset: 0,
                    context: .init(
                        display_default_code: false,
                        tz: context.tz,
                        false_name_ar: true,
                        uid: context.uid,
                        lang: context.lang
                    ),
                    fields: [
                        "id",
                        "display_name",
                        "lst_price",
                        "image_small",
                        "original_name",
                        "name_ar",
                        "other_lang_name",
                        "product_variant_ids",
                        "sequence"
                    ],
                    limit: false,
                    method: "search_read"
                ),
                jsonrpc: "2.0",
                method: "call",
                id: 1
            )
    }
    //MARK: - EndPoints Functions
    func login(completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        let loginRequestBody = createLoginRequestBody()
        makeRequest(urlString: Constants.EndPoints.login, method: "POST", requestBody: loginRequestBody, completion: completion)
    }
    
    func fetchProducts(for authUser: LoginResponse, completion: @escaping (Result<Products, APIError>) -> Void) {
        let requestBody = createFetchProductsRequestBody(for: authUser)
        makeRequest(urlString: Constants.EndPoints.products, method: "POST", requestBody: requestBody, completion: completion)
    }
}
