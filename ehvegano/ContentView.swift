//
//  ContentView.swift
//  ehvegano
//
//  Created by Eduardo Tolmasquim on 18/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var controller = ContentController()
    @State private var ean: String = ""
    
    var body: some View {
        ZStack {
            ResultView(
                product: $controller.product,
                notFound: $controller.notFound,
                errorMessage: $controller.errorMessage,
                isFetching: $controller.isFetching
            )
            EanTextField(controller: controller, ean: $ean)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ResultView: View {
    
    @Binding var product: Product?
    @Binding var notFound: Bool
    @Binding var errorMessage: String?
    @Binding var isFetching: Bool
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ActivityIndicator(isAnimating: isFetching)
                if product != nil {
                    VStack() {
                        imageFor(type: product!.type)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text(product!.type.description).font(.headline)
                            .padding(.bottom, 20)
                        Text(product!.name)
                    }
                }
                if notFound {
                    Text("Produto não encontrado")
                }
                if errorMessage != nil {
                    Text(errorMessage!)
                }
            }
            Spacer()
            Spacer()
            Spacer()
        }
    }
    
    func imageFor(type: Product.ProductType) -> Image {
        var image: Image
        switch type {
        case .vegan: image = Image(systemName: "leaf.arrow.circlepath")
        case .notVegan: image = Image(systemName: "xmark.octagon")
        case .unknown: image = Image(systemName: "questionmark")
        }
        return image
    }
}
    

struct EanTextField: View {
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    var controller: ContentController
    @Binding var ean: String
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            HStack {
                TextField("EAN...", text: self.$ean)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    guard self.ean != "" else { return }
                    self.controller.checkProduct(ean: self.ean)
                }) {
                    Image(systemName: "magnifyingglass")
                    Text("Buscar")
                }
            }
            .padding(.bottom, keyboardResponder.currentHeight/2)
            .animation(.easeOut(duration: 0.16))
            Spacer()
        }.padding()
    }
}
