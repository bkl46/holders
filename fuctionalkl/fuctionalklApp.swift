//
//  fuctionalklApp.swift
//  fuctionalkl
//
//  Created by Brandon Lee on 4/1/25.
//

import SwiftUI
import FamilyControls

@main
struct fuctionalklApp: App {
    init() {
        Task {
            try? await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
