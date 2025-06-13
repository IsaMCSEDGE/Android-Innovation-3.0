//
//  LoginView.swift
//  AI  App 3.0
//
//  Created by Isa Muniz on 6/13/25.
//


import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var authManager = AuthenticationManager()
    @State private var showingMainApp = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    themeManager.currentTheme.backgroundColor,
                    themeManager.currentTheme.primaryColor.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Logo and Title
                VStack(spacing: 20) {
                    // Logo placeholder - you can replace with your rafi-logo
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundColor(themeManager.currentTheme.accentColor)
                    
                    VStack(spacing: 8) {
                        Text("RAFI AI")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .themedText(themeManager.currentTheme)
                        
                        Text("Your AI Learning Assistant")
                            .font(.title3)
                            .themedText(themeManager.currentTheme)
                            .opacity(0.8)
                    }
                }
                
                Spacer()
                
                // Login Section
                VStack(spacing: 20) {
                    Text("Welcome!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .themedText(themeManager.currentTheme)
                    
                    Text("Sign in to access your personalized AI chat experience")
                        .font(.body)
                        .themedText(themeManager.currentTheme)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Apple Sign-In Button
                    SignInWithAppleButton(
                        onRequest: { request in
                            authManager.handleSignInWithAppleRequest(request)
                        },
                        onCompletion: { result in
                            authManager.handleSignInWithAppleCompletion(result) {
                                showingMainApp = true
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    
                    // Demo Login Button (for simulator testing)
                    Button(action: {
                        authManager.simulateLogin {
                            showingMainApp = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                            Text("Demo Login (Simulator)")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(themeManager.currentTheme.secondaryColor)
                        .foregroundColor(themeManager.currentTheme.textColor)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Footer
                Text("Secure authentication powered by Apple")
                    .font(.caption)
                    .themedText(themeManager.currentTheme)
                    .opacity(0.6)
                    .padding(.bottom, 30)
            }
        }
        .fullScreenCover(isPresented: $showingMainApp) {
            ContentView()
                .environmentObject(themeManager)
        }
    }
}

// MARK: - Authentication Manager
class AuthenticationManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: User?
    
    init() {
        checkExistingAuth()
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>, completion: @escaping () -> Void) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                let userID = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                // Create user object
                let user = User(
                    id: userID,
                    email: email ?? "user@example.com",
                    name: "\(fullName?.givenName ?? "User") \(fullName?.familyName ?? "")"
                )
                
                // Save user session
                saveUserSession(user)
                
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isSignedIn = true
                    completion()
                }
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
    
    // Demo login for simulator testing
    func simulateLogin(completion: @escaping () -> Void) {
        let demoUser = User(
            id: "demo_user_123",
            email: "demo@example.com",
            name: "Demo User"
        )
        
        saveUserSession(demoUser)
        
        DispatchQueue.main.async {
            self.currentUser = demoUser
            self.isSignedIn = true
            completion()
        }
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "current_user")
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isSignedIn = false
        }
    }
    
    private func checkExistingAuth() {
        if let userData = UserDefaults.standard.data(forKey: "current_user"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            DispatchQueue.main.async {
                self.currentUser = user
                self.isSignedIn = true
            }
        }
    }
    
    private func saveUserSession(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "current_user")
        }
    }
}

// MARK: - User Model
struct User: Codable {
    let id: String
    let email: String
    let name: String
}

#Preview {
    LoginView()
        .environmentObject(ThemeManager())
}