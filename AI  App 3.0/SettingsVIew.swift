import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSignOutAlert = false
    
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
                        // Creates flexible UI so if more themes are added it still fits
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            // Checks the available theme and allows for an animation when one is selected
                            ForEach(ThemeManager.availableThemes, id: \.name) { theme in
                                ThemeCard(
                                    theme: theme,
                                    isSelected: theme.name == themeManager.currentTheme.name
                                ) {
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        themeManager.setTheme(theme)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // User Account Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Account")
                            .font(.headline)
                            .themedText(themeManager.currentTheme)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            if let user = authManager.currentUser {
                                InfoRow(title: "Name", value: user.name)
                                InfoRow(title: "Email", value: user.email)
                            }
                            
                            // Sign Out Button
                            Button(action: {
                                showingSignOutAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Sign Out")
                                    Spacer()
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                            }
                        }
                        .themedSurface(themeManager.currentTheme)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About RAFI AI")
                            .font(.headline)
                            .themedText(themeManager.currentTheme)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            InfoRow(title: "Version", value: "1.0.3")
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
            // Sets up the theme manager for the settings view
            .themedBackground(themeManager.currentTheme)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbarBackground(themeManager.currentTheme.backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.accentColor)
                }
            }
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authManager.signOut()
                    // Force dismiss all modals and sheets
                    presentationMode.wrappedValue.dismiss()
                    
                    // Additional force refresh - post notification
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        NotificationCenter.default.post(name: NSNotification.Name("ForceLogout"), object: nil)
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
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
        .environmentObject(AuthenticationManager())
}
