//
//  AI__App_3_0App.swift
//  AI  App 3.0
//
//  Created by Isa Muniz on 6/4/25.
//

import SwiftUI
import SwiftData

@main
struct AI__App_3_0App: App {
    // Create ONE ThemeManager for the entire app
    @StateObject private var themeManager = ThemeManager()
    
    // Create ONE AuthenticationManager for the entire app
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isSignedIn {
                    // User is logged in - show main app
                    ContentView()
                        .environmentObject(themeManager)
                        .environmentObject(authManager) // Pass the SAME authManager
                } else {
                    // User not logged in - show login
                    LoginView()
                        .environmentObject(themeManager)
                        .environmentObject(authManager) // Pass the SAME authManager
                }
            }
        }
    }
    
}
