//
//  Theme.swift
//  AI  App 3.0
//
//  Created by Isa Muniz on 6/4/25.
//

import SwiftUI

// MARK: - Theme Protocol
protocol Theme {
    var name: String { get }
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var backgroundColor: Color { get }
    var surfaceColor: Color { get }
    var textColor: Color { get }
    var accentColor: Color { get }
}

// MARK: - Theme Implementations
struct StarlightTheme: Theme {
    let name = "Starlight"
    let primaryColor = Color(red: 0.2, green: 0.1, blue: 0.4) // Deep purple
    let secondaryColor = Color(red: 0.4, green: 0.2, blue: 0.6) // Medium purple
    let backgroundColor = Color.black
    let surfaceColor = Color(red: 0.1, green: 0.1, blue: 0.2) // Dark purple-black
    let textColor = Color.white
    let accentColor = Color(red: 0.8, green: 0.6, blue: 1.0) // Light purple
}
//struct GardenTheme: Theme {
//    let name = "Garden"
//    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.3) // Forest green // Deep purple
//    let secondaryColor = Color(red: 0.8, green: 0.6, blue: 1.0) // light purple
//    let backgroundColor = Color.white
//    let surfaceColor = Color(red: 1.0, green: 0.8, blue: 0.4) // Light golden
//    let textColor = Color.white
//    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.9) // Light rose
//}
struct OceanTheme: Theme {
    let name = "Ocean"
    let primaryColor = Color(red: 0.0, green: 0.5, blue: 0.5) // Teal
    let secondaryColor = Color(red: 0.2, green: 0.6, blue: 0.8) // Ocean blue
    let backgroundColor = Color(red: 0.05, green: 0.15, blue: 0.25) // Deep ocean
    let surfaceColor = Color(red: 0.1, green: 0.3, blue: 0.4) // Medium ocean
    let textColor = Color.white
    let accentColor = Color(red: 0.4, green: 0.8, blue: 0.9) // Light teal
}

struct SunsetTheme: Theme {
    let name = "Sunset"
    let primaryColor = Color(red: 1.0, green: 0.4, blue: 0.2) // Orange-red
    let secondaryColor = Color(red: 1.0, green: 0.6, blue: 0.0) // Golden orange
    let backgroundColor = Color(red: 0.2, green: 0.1, blue: 0.1) // Dark red-brown
    let surfaceColor = Color(red: 0.3, green: 0.2, blue: 0.1) // Warm brown
    let textColor = Color.white
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.4) // Light golden
}

struct ForestTheme: Theme {
    let name = "Forest"
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.3) // Forest green
    let secondaryColor = Color(red: 0.4, green: 0.7, blue: 0.2) // Lime green
    let backgroundColor = Color(red: 0.1, green: 0.2, blue: 0.1) // Dark forest
    let surfaceColor = Color(red: 0.15, green: 0.3, blue: 0.15) // Medium forest
    let textColor = Color.white
    let accentColor = Color(red: 0.6, green: 0.9, blue: 0.4) // Light green
}

struct RoseGoldTheme: Theme {
    let name = "Rose Gold"
    let primaryColor = Color(red: 0.9, green: 0.6, blue: 0.7) // Rose gold
    let secondaryColor = Color(red: 0.8, green: 0.4, blue: 0.6) // Deep rose
    let backgroundColor = Color(red: 0.15, green: 0.1, blue: 0.1) // Dark rose
    let surfaceColor = Color(red: 0.25, green: 0.15, blue: 0.15) // Medium rose
    let textColor = Color.white
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.9) // Light rose
}

struct LavenderTheme: Theme {
    let name = "Lavender"
    let primaryColor = Color(red: 0.7, green: 0.6, blue: 0.9) // Lavender
    let secondaryColor = Color(red: 0.6, green: 0.4, blue: 0.8) // Deep lavender
    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15) // Dark lavender
    let surfaceColor = Color(red: 0.2, green: 0.15, blue: 0.25) // Medium lavender
    let textColor = Color.white
    let accentColor = Color(red: 0.9, green: 0.8, blue: 1.0) // Light lavender
}

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme
    
    static let availableThemes: [Theme] = [
        StarlightTheme(),
        OceanTheme(),
        SunsetTheme(),
        ForestTheme(),
        RoseGoldTheme(),
        LavenderTheme()
    ]
    
    init() {
        // Load saved theme or default to Starlight
        if let savedThemeName = UserDefaults.standard.string(forKey: "selectedTheme"),
           let savedTheme = ThemeManager.availableThemes.first(where: { $0.name == savedThemeName }) {
            self.currentTheme = savedTheme
        } else {
            self.currentTheme = StarlightTheme()
        }
    }
    
    func setTheme(_ theme: Theme) {
        currentTheme = theme
        UserDefaults.standard.set(theme.name, forKey: "selectedTheme")
    }
}

// MARK: - View Extensions
extension View {
    func themedBackground(_ theme: Theme) -> some View {
        self.background(theme.backgroundColor)
    }
    
    func themedSurface(_ theme: Theme) -> some View {
        self.background(theme.surfaceColor)
            .cornerRadius(10)
    }
    
    func themedText(_ theme: Theme) -> some View {
        self.foregroundColor(theme.textColor)
    }
    
    func themedPrimary(_ theme: Theme) -> some View {
        self.background(theme.primaryColor)
            .foregroundColor(theme.textColor)
    }
    
    func themedSecondary(_ theme: Theme) -> some View {
        self.background(theme.secondaryColor)
            .foregroundColor(theme.textColor)
    }
}
