//
//  ContentView.swift
//  ehvegano
//
//  Created by Eduardo Tolmasquim on 18/04/20.
//  Copyright © 2020 Eduardo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var controller = ContentController()
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
                    VStack(spacing: 20) {
                        Text(product!.type.description)
                        Text(product!.name)
                            .font(.title)
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
        }
    }
}
    

struct EanTextField: View {
    
    var controller: ContentController
    @Binding var ean: String
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            TextField("EAN...", text: $ean, onCommit: {
                guard self.ean != "" else { return }
                self.controller.checkProduct(ean: self.ean)
            } ).textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
        }.padding()
    }
}
