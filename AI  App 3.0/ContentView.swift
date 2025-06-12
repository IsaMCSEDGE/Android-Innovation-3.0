import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Chat.dateCreated, ascending: false)],
        animation: .default)
    private var chats: FetchedResults<Chat>
    
    @State private var showingSettings = false
    @State private var showingNameAlert = false
    @State private var newChatName = ""
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            VStack {
                if chats.isEmpty {
                    // Empty state - big plus button
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Button(action: {
                            showingNameAlert = true
                        }) {
                            VStack(spacing: 20) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(themeManager.currentTheme.accentColor)
                                
                                Text("Click to Chat")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .themedText(themeManager.currentTheme)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                } else {
                    // Chat list
                    List {
                        ForEach(chats, id: \.self) { chat in
                            NavigationLink(destination: AIChatView(chat: chat)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chat.name ?? "Unnamed Chat")
                                        .themedText(themeManager.currentTheme)
                                        .font(.headline)
                                    
                                    Text(formatDate(chat.dateCreated))
                                        .themedText(themeManager.currentTheme)
                                        .font(.caption)
                                        .opacity(0.7)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(themeManager.currentTheme.surfaceColor)
                        }
                        .onDelete(perform: deleteChats)
                    }
                    .listStyle(PlainListStyle())
                    .themedBackground(themeManager.currentTheme)
                    .scrollContentBackground(.hidden)

                    Button(action: {
                        showingNameAlert = true
                    }) {
                        Text("New Chat")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .themedPrimary(themeManager.currentTheme)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .themedBackground(themeManager.currentTheme)
            .navigationTitle("RAFI AI")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark)
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
            .alert("Name Your Chat", isPresented: $showingNameAlert) {
                TextField("Chat name", text: $newChatName)
                Button("Create") {
                    createNewChat(name: newChatName)
                    newChatName = ""
                }
                Button("Cancel", role: .cancel) {
                    newChatName = ""
                }
            } message: {
                Text("Give your chat a memorable name")
            }
        }
    }

    private func createNewChat(name: String) {
        withAnimation {
            let newChat = Chat(context: viewContext)
            newChat.name = name.isEmpty ? "New Chat" : name
            newChat.dateCreated = Date()
            
            do {
                try viewContext.save()
            } catch {
                print("Error saving chat: \(error)")
            }
        }
    }
    
    private func deleteChats(offsets: IndexSet) {
        withAnimation {
            offsets.map { chats[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting chat: \(error)")
            }
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
