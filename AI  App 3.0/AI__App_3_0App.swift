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
    @StateObject private var themeManager = ThemeManager()
        
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(themeManager)
            }
        }
    }
