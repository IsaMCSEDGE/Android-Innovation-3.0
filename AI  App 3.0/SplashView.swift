import SwiftUI

struct SplashView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var logoOpacity: Double = 0.0
    @State private var logoScale: Double = 0.8
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            // Background using current theme
            themeManager.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo with animations
                Image("rafi-logo") // Update this to match your exact asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .opacity(logoOpacity)
                    .scaleEffect(logoScale)
                    .background(Color.red.opacity(0.3)) // Temporary: shows logo boundaries
                
                // Temporary: Debug text to see if theme is working
                Text("RAFI AI")
                    .font(.title)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .opacity(logoOpacity)
            }
        }
        .onAppear {
            startAnimation()
        }
        .fullScreenCover(isPresented: $showMainApp) {
            ContentView()
                .environmentObject(themeManager)
        }
    }
    
    private func startAnimation() {
        // Fade in and scale up animation
        withAnimation(.easeInOut(duration: 1.5)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // After animation completes, wait a bit then show main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showMainApp = true
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(ThemeManager())
}
