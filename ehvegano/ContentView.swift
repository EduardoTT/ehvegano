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
        NavigationView {
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
            ZStack {
                ActivityIndicator(isAnimating: isFetching)
                if product != nil {
                    VStack {
                        imageFor(type: product!.type)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(colorFor(type: product!.type))
                        Text(product!.type.description).font(.headline)
                            .padding(.bottom, 20)
                            .foregroundColor(colorFor(type: product!.type))
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
    
    private func imageFor(type: Product.ProductType) -> Image {
        switch type {
        case .vegan:
            return Image(systemName: "leaf.arrow.circlepath")
        case .notVegan:
            return Image(systemName: "xmark.octagon")
        case .unknown:
            return Image(systemName: "questionmark")
        }
    }
    
    private func colorFor(type: Product.ProductType) -> Color {
        switch type {
        case .vegan:
            return Color.green
        case .notVegan:
            return Color.red
        case .unknown:
            return Color.yellow
        }
    }
}
    

struct EanTextField: View {
    @ObservedObject private var keyboardResponder = KeyboardResponder()
//    @ObservedObject private var scanner = ScannerViewController()
    @State var isActive = false
    var controller: ContentController
    @Binding var ean: String
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            NavigationLink(destination: ScannerViewControllerRepresentable(isActive: $isActive, code: $ean), isActive: $isActive) {
                Image(systemName: "barcode.viewfinder")
                    .font(.title)
                Text("Escanear")
                    .font(.title)
            }
            Spacer()
            HStack {
                TextField("EAN...", text: $ean)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    guard self.ean != "" else { return }
                    self.controller.checkProduct(ean: self.ean)

                }, label: {
                    Image(systemName: "magnifyingglass")
                    Text("Buscar")
                })
            }
            .padding(.bottom, keyboardResponder.currentHeight*0.7)
            .animation(.easeOut(duration: 0.16))
            Spacer()
        }.padding()
    }
}
    
