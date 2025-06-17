import SwiftUI
import Foundation

struct ContentView: View {
    // Shows tohe two chats the the users can interact with
    @State private var chats: [ChatItem] = [
        ChatItem(id: UUID(), name: "Welcome Chat", dateCreated: Date()),
        ChatItem(id: UUID(), name: "Study Session", dateCreated: Date().addingTimeInterval(-3600))
    ]
    
    @State private var showingSettings = false
    @EnvironmentObject var themeManager: ThemeManager
    
    //Variables for editing functionality
    @State private var editingChatId: UUID? = nil
    @State private var editingText: String = ""
    @State private var showingDeleteAlert = false
    @State private var chatToDelete: ChatItem? = nil

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(chats) { chat in
                        if editingChatId == chat.id {
                            //  Shows text field for renaming
                            HStack {
                                TextField("Chat name", text: $editingText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onSubmit {
                                        finishEditing()
                                    }
                                
                                // Save button
                                Button("Save") {
                                    finishEditing()
                                }
                                .foregroundColor(themeManager.currentTheme.accentColor)
                                
                                // Cancel button
                                Button("Cancel") {
                                    cancelEditing()
                                }
                                .foregroundColor(.red)
                            }
                            .listRowBackground(themeManager.currentTheme.surfaceColor)
                        } else {
                            // Show chat with navigation
                            NavigationLink(destination: AIChatView(chatTitle: chat.name)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chat.name)
                                        .themedText(themeManager.currentTheme)
                                        .fontWeight(.medium)
                                    
                                    Text(formatDate(chat.dateCreated))
                                        .font(.caption)
                                        .themedText(themeManager.currentTheme)
                                        .opacity(0.6)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(themeManager.currentTheme.surfaceColor)
                            //Swipe actions for each chat
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // Delete action 
                                Button(role: .destructive) {
                                    chatToDelete = chat
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                // Rename action 
                                Button {
                                    startEditing(chat: chat)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                                .tint(themeManager.currentTheme.accentColor)
                            }
                            // Long press alternitive to swipe
                            .contextMenu {
                                Button {
                                    startEditing(chat: chat)
                                } label: {
                                    Label("Rename Chat", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    chatToDelete = chat
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete Chat", systemImage: "trash")
                                }
                            }
                        }
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
            // Borrows theme manager to this file
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
            // Delete confirmation alert
            .alert("Delete Chat", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    chatToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let chat = chatToDelete {
                        deleteChat(chat)
                    }
                    chatToDelete = nil
                }
            } message: {
                if let chat = chatToDelete {
                    Text("Are you sure you want to delete '\(chat.name)'? This action cannot be undone.")
                }
            }
        }
    }

    // Function to create a new chat with a unique name
    private func createNewChat() {
        let newChatNumber = chats.count + 1
        let newChat = ChatItem(
            id: UUID(),
            name: "Chat \(newChatNumber)",
            dateCreated: Date()
        )
        chats.insert(newChat, at: 0) // Add to top of list
    }
    
    // Function to start editing a chat name
    private func startEditing(chat: ChatItem) {
        editingChatId = chat.id
        editingText = chat.name
    }
    
    // Function to save the edited name
    private func finishEditing() {
        guard let editingId = editingChatId else { return }
        
        // Find the chat and update its name
        if let index = chats.firstIndex(where: { $0.id == editingId }) {
            // Make sure the name isn't empty
            let newName = editingText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !newName.isEmpty {
                chats[index].name = newName
            }
        }
        
        // Exit edit mode
        editingChatId = nil
        editingText = ""
    }
    
    // Function to cancel editing
    private func cancelEditing() {
        editingChatId = nil
        editingText = ""
    }
    
    //  Function to delete a chat
    private func deleteChat(_ chat: ChatItem) {
        chats.removeAll { $0.id == chat.id }
    }
    
    //  Function to format the date nicely
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            // It's today
            formatter.timeStyle = .short
            return "Today, \(formatter.string(from: date))"
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()),
                  calendar.isDate(date, inSameDayAs: yesterday) {
            // It's yesterday
            formatter.timeStyle = .short
            return "Yesterday, \(formatter.string(from: date))"
        } else {
            // It's another day
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}

//  Data model for chat items
struct ChatItem: Identifiable {
    let id: UUID
    var name: String
    let dateCreated: Date
    
    init(id: UUID = UUID(), name: String, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.dateCreated = dateCreated
    }
}
