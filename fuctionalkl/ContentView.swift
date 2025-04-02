//
//  ContentView.swift
//  fuctionalkl
//
//  Created by Brandon Lee on 4/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Instagram Control")
                .font(.title)
                .padding()
            
            InstagramToggleView()
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
