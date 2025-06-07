//
//  SettingsVIew.swift
//  AI  App 3.0
//
//  Created by Isa Muniz on 6/4/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack {
                        Image(systemName: "paintbrush.fill")
                            .font(.system(size: 50))
                            .foregroundColor(themeManager.currentTheme.accentColor)
                        
                        Text("Customize Your Experience")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .themedText(themeManager.currentTheme)
                            .multilineTextAlignment(.center)
                        
                        Text("Choose a theme that makes learning more enjoyable!")
                            .font(.subheadline)
                            .themedText(themeManager.currentTheme)
                            .opacity(0.8)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Theme Selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Themes")
                            .font(.headline)
                            .themedText(themeManager.currentTheme)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            ForEach(ThemeManager.availableThemes, id: \.name) { theme in
                                ThemeCard(
                                    theme: theme,
                                    isSelected: theme.name == themeManager.currentTheme.name
                                ) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        themeManager.setTheme(theme)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About RAFI AI")
                            .font(.headline)
                            .themedText(themeManager.currentTheme)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            InfoRow(title: "Version", value: "1.0")
                            InfoRow(title: "Developer", value: "Israel Muñiz")
                            InfoRow(title: "Purpose", value: "Assisting students with learning disabilities")
                        }
                        .themedSurface(themeManager.currentTheme)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .themedBackground(themeManager.currentTheme)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.accentColor)
                }
            }
        }
    }
}

struct ThemeCard: View {
    let theme: Theme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme preview circles
                HStack(spacing: 8) {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(theme.secondaryColor)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(theme.accentColor)
                        .frame(width: 20, height: 20)
                }
                
                Text(theme.name)
                    .font(.headline)
                    .foregroundColor(theme.textColor)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.accentColor)
                        .font(.title2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(theme.surfaceColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? theme.accentColor : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(title)
                .themedText(themeManager.currentTheme)
                .opacity(0.8)
            Spacer()
            Text(value)
                .themedText(themeManager.currentTheme)
                .fontWeight(.medium)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
