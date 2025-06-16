import SwiftUI

// NEW- Theme Protocol
protocol Theme {
    var name: String { get }
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var backgroundColor: Color { get }
    var surfaceColor: Color { get }
    var textColor: Color { get }
    var accentColor: Color { get }
}

// NEW - Theme Implementations
struct StarlightTheme: Theme {
    let name = "Starlight"
    let primaryColor = Color(red: 0.2, green: 0.1, blue: 0.4) // Deep purple
    let secondaryColor = Color(red: 0.4, green: 0.2, blue: 0.6) // Medium purple
    let backgroundColor = Color.black
    let surfaceColor = Color(red: 0.1, green: 0.1, blue: 0.2) // Dark purple-black
    let textColor = Color.white
    let accentColor = Color(red: 0.8, green: 0.6, blue: 1.0) // Light purple
}

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

//Calming/Study-Friendly Themes
struct MidnightTheme: Theme {
    let name = "Midnight"
    let primaryColor = Color(red: 0.1, green: 0.2, blue: 0.4) // Deep navy
    let secondaryColor = Color(red: 0.2, green: 0.3, blue: 0.5) // Medium navy
    let backgroundColor = Color(red: 0.05, green: 0.05, blue: 0.1) // Almost black
    let surfaceColor = Color(red: 0.15, green: 0.2, blue: 0.3) // Dark blue-gray
    let textColor = Color.white
    let accentColor = Color(red: 0.7, green: 0.8, blue: 0.9) // Silver-blue
}

struct SageTheme: Theme {
    let name = "Sage"
    let primaryColor = Color(red: 0.4, green: 0.5, blue: 0.4) // Sage green
    let secondaryColor = Color(red: 0.5, green: 0.6, blue: 0.5) // Light sage
    let backgroundColor = Color(red: 0.1, green: 0.15, blue: 0.1) // Dark earth
    let surfaceColor = Color(red: 0.2, green: 0.25, blue: 0.2) // Medium earth
    let textColor = Color.white
    let accentColor = Color(red: 0.7, green: 0.8, blue: 0.7) // Light sage
}

struct ArcticTheme: Theme {
    let name = "Arctic"
    let primaryColor = Color(red: 0.4, green: 0.6, blue: 0.8) // Cool blue
    let secondaryColor = Color(red: 0.6, green: 0.7, blue: 0.9) // Light blue
    let backgroundColor = Color(red: 0.05, green: 0.1, blue: 0.15) // Dark ice
    let surfaceColor = Color(red: 0.15, green: 0.25, blue: 0.35) // Ice blue
    let textColor = Color.white
    let accentColor = Color(red: 0.8, green: 0.9, blue: 1.0) // Ice white
}

// Vibrant/Energizing Themes
struct NeonTheme: Theme {
    let name = "Neon"
    let primaryColor = Color(red: 1.0, green: 0.0, blue: 0.5) // Hot pink
    let secondaryColor = Color(red: 0.0, green: 1.0, blue: 0.5) // Electric green
    let backgroundColor = Color.black
    let surfaceColor = Color(red: 0.1, green: 0.1, blue: 0.1) // Dark gray
    let textColor = Color.white
    let accentColor = Color(red: 0.0, green: 0.8, blue: 1.0) // Electric blue
}

struct TropicalTheme: Theme {
    let name = "Tropical"
    let primaryColor = Color(red: 1.0, green: 0.5, blue: 0.0) // Bright orange
    let secondaryColor = Color(red: 0.2, green: 0.8, blue: 0.2) // Tropical green
    let backgroundColor = Color(red: 0.05, green: 0.2, blue: 0.1) // Deep jungle
    let surfaceColor = Color(red: 0.1, green: 0.3, blue: 0.2) // Jungle green
    let textColor = Color.white
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.0) // Sunshine yellow
}

struct GalaxyTheme: Theme {
    let name = "Galaxy"
    let primaryColor = Color(red: 0.6, green: 0.2, blue: 0.8) // Deep purple
    let secondaryColor = Color(red: 0.8, green: 0.2, blue: 0.6) // Cosmic pink
    let backgroundColor = Color(red: 0.05, green: 0.0, blue: 0.1) // Space black
    let surfaceColor = Color(red: 0.15, green: 0.05, blue: 0.2) // Dark space
    let textColor = Color.white
    let accentColor = Color(red: 1.0, green: 0.4, blue: 0.8) // Bright pink
}

// Accessible/High-Contrast Themes
struct ClassicTheme: Theme {
    let name = "Classic"
    let primaryColor = Color.black
    let secondaryColor = Color(red: 0.3, green: 0.3, blue: 0.3) // Dark gray
    let backgroundColor = Color.white
    let surfaceColor = Color(red: 0.95, green: 0.95, blue: 0.95) // Light gray
    let textColor = Color.black
    let accentColor = Color.blue
}

struct AmberTheme: Theme {
    let name = "Amber"
    let primaryColor = Color(red: 1.0, green: 0.6, blue: 0.0) // Amber
    let secondaryColor = Color(red: 1.0, green: 0.8, blue: 0.3) // Light amber
    let backgroundColor = Color.black
    let surfaceColor = Color(red: 0.2, green: 0.1, blue: 0.0) // Dark amber
    let textColor = Color(red: 1.0, green: 0.9, blue: 0.7) // Warm white
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.0) // Golden
}

//  Seasonal Themes
struct AutumnTheme: Theme {
    let name = "Autumn"
    let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.1) // Burnt orange
    let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1) // Deep orange
    let backgroundColor = Color(red: 0.15, green: 0.1, blue: 0.05) // Dark brown
    let surfaceColor = Color(red: 0.25, green: 0.15, blue: 0.1) // Medium brown
    let textColor = Color.white
    let accentColor = Color(red: 1.0, green: 0.7, blue: 0.2) // Golden yellow
}

struct WinterTheme: Theme {
    let name = "Winter"
    let primaryColor = Color(red: 0.3, green: 0.5, blue: 0.7) // Winter blue
    let secondaryColor = Color(red: 0.5, green: 0.7, blue: 0.8) // Light winter blue
    let backgroundColor = Color(red: 0.05, green: 0.08, blue: 0.12) // Deep winter
    let surfaceColor = Color(red: 0.15, green: 0.2, blue: 0.3) // Winter gray
    let textColor = Color.white
    let accentColor = Color(red: 0.8, green: 0.9, blue: 1.0) // Snow white
}

// NEW - Theme Manager
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme
    
    static let availableThemes: [Theme] = [
        StarlightTheme(),
        OceanTheme(),
        SunsetTheme(),
        ForestTheme(),
        RoseGoldTheme(),
        LavenderTheme(),
        // Calming/Study-Friendly
        MidnightTheme(),
        SageTheme(),
        ArcticTheme(),
        // Vibrant/Energizing
        NeonTheme(),
        TropicalTheme(),
        GalaxyTheme(),
        // Accessible/High-Contrast
        ClassicTheme(),
        AmberTheme(),
        // Seasonal
        AutumnTheme(),
        WinterTheme()
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
