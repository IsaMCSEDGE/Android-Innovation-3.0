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
    @EnvironmentObject var authManager: AuthenticationManager
    
    // NEW: State variables for username/password login
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
            
            ScrollView { // NEW: Added ScrollView so keyboard doesn't cover content
                VStack(spacing: 30) {
                    Spacer(minLength: 50)
                    
                    // App Logo and Title
                    VStack(spacing: 20) {
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
                    
                    // NEW: Username and Password Section
                    VStack(spacing: 20) {
                        Text("Sign In")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .themedText(themeManager.currentTheme)
                        
                        // Username Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .themedText(themeManager.currentTheme)
                                .opacity(0.8)
                            
                            TextField("Enter your username", text: $username)
                                .textFieldStyle(CustomTextFieldStyle(theme: themeManager.currentTheme))
                                .autocapitalization(.none) // Don't auto-capitalize usernames
                                .disableAutocorrection(true) // Don't auto-correct usernames
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .themedText(themeManager.currentTheme)
                                .opacity(0.8)
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(CustomTextFieldStyle(theme: themeManager.currentTheme))
                        }
                        
                        // Sign In Button
                        Button(action: {
                            loginWithUsernamePassword()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: themeManager.currentTheme.textColor))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                    Text("Sign In")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                // Disable button if fields are empty or loading
                                (username.isEmpty || password.isEmpty || isLoading) ?
                                themeManager.currentTheme.secondaryColor.opacity(0.5) :
                                themeManager.currentTheme.primaryColor
                            )
                            .foregroundColor(themeManager.currentTheme.textColor)
                            .cornerRadius(10)
                        }
                        .disabled(username.isEmpty || password.isEmpty || isLoading)
                        .padding(.horizontal, 40)
                    }
                    .padding(.horizontal, 20)
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(themeManager.currentTheme.textColor.opacity(0.3))
                        
                        Text("OR")
                            .font(.caption)
                            .themedText(themeManager.currentTheme)
                            .opacity(0.6)
                            .padding(.horizontal, 10)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(themeManager.currentTheme.textColor.opacity(0.3))
                    }
                    .padding(.horizontal, 40)
                    
                    // Alternative Login Methods
                    VStack(spacing: 15) {
                        Text("Quick Sign In Options")
                            .font(.subheadline)
                            .themedText(themeManager.currentTheme)
                            .opacity(0.7)
                        
                        // Apple Sign-In Button
                        SignInWithAppleButton(
                            onRequest: { request in
                                authManager.handleSignInWithAppleRequest(request)
                            },
                            onCompletion: { result in
                                authManager.handleSignInWithAppleCompletion(result) {
                                    // Navigation happens automatically now!
                                }
                            }
                        )
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        
                        // Demo Login Button
                        Button(action: {
                            authManager.simulateLogin {
                                // Navigation happens automatically now!
                            }
                        }) {
                            HStack {
                                Image(systemName: "bolt.circle.fill")
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
                    
                    Spacer(minLength: 30)
                    
                    // Footer
                    Text("Secure authentication powered by Apple")
                        .font(.caption)
                        .themedText(themeManager.currentTheme)
                        .opacity(0.6)
                        .padding(.bottom, 30)
                }
            }
        }
        .alert("Login Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // NEW: Function to handle username/password login
    private func loginWithUsernamePassword() {
        // Show loading state
        isLoading = true
        
        // Call the auth manager to handle login
        authManager.loginWithUsernamePassword(username: username, password: password) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if !success {
                    // Show error alert
                    alertMessage = error ?? "Login failed. Please try again."
                    showingAlert = true
                    
                    // Clear password field for security
                    password = ""
                }
                // If successful, navigation happens automatically
            }
        }
    }
}

// NEW: Custom text field style that matches your theme
struct CustomTextFieldStyle: TextFieldStyle {
    let theme: Theme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(theme.surfaceColor)
            .foregroundColor(theme.textColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.accentColor.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Enhanced Authentication Manager
class AuthenticationManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: User?
    
    init() {
        checkExistingAuth()
    }
    
    // NEW: Username/Password login function
    func loginWithUsernamePassword(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Here you would normally call your server API
        // For now, we'll simulate it with some demo accounts
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Demo accounts for testing
            let demoAccounts = [
                ("student", "password123"),
                ("teacher", "teach2024"),
                ("admin", "admin123"),
                ("demo", "demo")
            ]
            
            // Check if credentials match any demo account
            if demoAccounts.contains(where: { $0.0 == username && $0.1 == password }) {
                // Create user object
                let user = User(
                    id: "user_\(username)",
                    email: "\(username)@example.com",
                    name: username.capitalized
                )
                
                // Save user session
                self.saveUserSession(user)
                
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isSignedIn = true
                    completion(true, nil)
                }
            } else {
                // Invalid credentials
                completion(false, "Invalid username or password. Try: student/password123")
            }
        }
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
                
                let user = User(
                    id: userID,
                    email: email ?? "user@example.com",
                    name: "\(fullName?.givenName ?? "User") \(fullName?.familyName ?? "")"
                )
                
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

struct User: Codable {
    let id: String
    let email: String
    let name: String
}

#Preview {
    LoginView()
        .environmentObject(ThemeManager())
        .environmentObject(AuthenticationManager())
}
