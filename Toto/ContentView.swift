//
//  ContentView.swift
//  Toto
//
//  Created by TAHIRI JOTEY Taha on 20/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .font(.system(size: 76))
                .foregroundStyle(Color.blue)
            Text("Hello, world!")

        }
        
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
