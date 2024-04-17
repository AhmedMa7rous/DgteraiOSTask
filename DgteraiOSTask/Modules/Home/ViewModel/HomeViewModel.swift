//
//  HomeViewModel.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 17/04/2024.
//

import SwiftUI
import Network

class HomeViewModel: ObservableObject {
    @Published var selectedProducts: [Product] = []
    @Published var loginResponse: LoginResponse?
    @Published var products: [Product]?
    @Published var isLoading: Bool = false
    @Published var error: APIError?
    
    private var isOnline: Bool {
        checkNetworkStatus()
    }
    
    var totalPrice: Double {
        calculateprice()
    }
    
    private let networkManager = NetworkManager.shared
    private let databaseManager = DatabaseManager.shared
    
    private func login() {
        isLoading = true
        networkManager.login { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.loginResponse = response
                    self?.fetchProducts(for: response)
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    private func fetchProducts(for authUser: LoginResponse) {
        isLoading = true
        networkManager.fetchProducts(for: authUser) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let products):
                    self?.products = products.result
                    self?.saveProductsToDatabase(products.result)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error
                }
            }
        }
    }
    
    private func saveProductsToDatabase(_ products: [Product]) {
        products.forEach { product in
            databaseManager.addProduct(product: product)
        }
    }
    
    private func checkNetworkStatus() -> Bool {
        let monitor = NWPathMonitor()
        
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
            
            semaphore.signal()
        }
        
        monitor.start(queue: DispatchQueue.global())
        
        _ = semaphore.wait(timeout: .now() + 5) // Wait for 5 seconds for the network check
        
        monitor.cancel()
        
        return isConnected
    }
    
    private func calculateprice() -> Double {
        selectedProducts.reduce(0) { $0 + Double($1.lstPrice * $1.quantity) }
    }
    
    func loadData() {
        if isOnline {
            databaseManager.deleteAllProducts()
            login()
        } else {
            products = databaseManager.getAllProducts()
        }
    }
    
    func getImage(for imageSmall: ImageSmall) -> Image {
        switch imageSmall {
        case .bool(_):
            return Image("placeholder")
        case .string(let stringValue):
            guard let data = Data(base64Encoded: stringValue, options: .ignoreUnknownCharacters),
                  let uiImage = UIImage(data: data) else {
                return Image("placeholder")
            }
            return Image(uiImage: uiImage)
        }
    }
    
    func selectProduct(_ product: Product) {
        if let existingProductIndex = selectedProducts.firstIndex(where: { $0.id == product.id }) {
            selectedProducts[existingProductIndex].quantity += 1
        } else {
            var newProduct = product
            newProduct.quantity = 1
            selectedProducts.append(newProduct)
        }
    }
    
    
}
