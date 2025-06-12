import SwiftUI

struct ContentView: View {
    @State private var chats: [String] = ["Chat 1", "Chat 2"]
    @State private var showingSettings = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(chats, id: \.self) { chat in
                        NavigationLink(destination: AIChatView(chatTitle: chat)) {
                            Text(chat)
                                .themedText(themeManager.currentTheme)
                                .padding(.vertical, 4)
                        }
                        .listRowBackground(themeManager.currentTheme.surfaceColor)
                    }
                }
                .listStyle(PlainListStyle())
                .themedBackground(themeManager.currentTheme)
                .scrollContentBackground(.hidden)

                Button(action: {
                    createNewChat()
                }) {
                    Text("New Chat")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .themedPrimary(themeManager.currentTheme)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .themedBackground(themeManager.currentTheme)
                        .navigationTitle("RAFI AI")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbarColorScheme(.dark) // This forces white text
                        .toolbarBackground(themeManager.currentTheme.backgroundColor, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(themeManager.currentTheme.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(themeManager)
            }
        }
    }

    private func createNewChat() {
        chats.append("New Chat \(chats.count + 1)")
    }
}
