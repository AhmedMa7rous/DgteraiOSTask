//
//  ContentView.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 17/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = HomeViewModel()
    
    //MARK: - Drawing Constants
    private let productItemHeight: CGFloat = 80.0
    private let orderCellHeight: CGFloat = 30.0
    private let cornerRadius: CGFloat = 8.0
    private let numberOfCollectionRows: Int = 3
    private let fontScaleFactor: CGFloat = 0.045
    
    //MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack {
                productsView(for: geometry.size)
                orderView(for: geometry.size)
                costView(title: "Total without taxes", price: "\(viewModel.totalPrice)")
                costView(title: "Tax", price: "0.65")
                totalView(title: "Pay now", price: "\(viewModel.totalPrice + 0.65)")
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .onAppear {
            viewModel.loadData()
        }
        
    }
    
    //MARK: - Support functions
    private func productsView(for size: CGSize) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: .init(), count: numberOfCollectionRows)) {
                ForEach(viewModel.products ?? [], id: \.id) { product in
                    productViewCell(for: product, with: size)
                        .onTapGesture {
                            viewModel.selectProduct(product)
                        }
                }
            }
        }
        .padding()
        .frame(height: size.height / 2.5)
    }
    
    private func productViewCell(for product: Product, with size: CGSize) -> some View {
       ZStack(alignment: .bottom) {
           viewModel.getImage(for: product.imageSmall)
                .resizable()
                .scaledToFill()
                .opacity(0.4)
                .frame(width: size.width / 4, height: productItemHeight)
                .cornerRadius(cornerRadius)
                .overlay(
                    VStack {
                        Spacer()
                        Text(product.displayName)
                            .font(Font.system(size: setFontSize(for: size)))
                            .fontWeight(.regular)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.bottom, 5)
                        
                        Text("\(product.lstPrice) SAR")
                            .font(Font.system(size: setFontSize(for: size)))
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                            .padding(.bottom, 5)
                    }
                )
        }
    }
    
    private func orderView(for size: CGSize) -> some View {
        List {
            ForEach(viewModel.selectedProducts, id: \.id) { product in
                orderViewCell(for: product, with: size)
            }
        }
    }
    
    private func orderViewCell(for product: Product, with size: CGSize) -> some View{
        HStack {
            Text(product.displayName)
                .font(Font.system(size: setFontSize(for: size)))
                .minimumScaleFactor(0.5)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                
            Spacer()
            
            Text("\(product.quantity)")
                .font(Font.system(size: setFontSize(for: size)))
                .foregroundColor(colorScheme == .dark ? .white : .gray)
        }
        .frame(height: orderCellHeight)
    }
    
    
    private func costView(title: String, price: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text(price)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
        
    private func totalView(title: String, price: String) -> some View {
        Button(action: {
            print("Paid")
        }) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(price)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
    
    ///This function set font size
    private func setFontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}



#Preview {
    ContentView()
}
