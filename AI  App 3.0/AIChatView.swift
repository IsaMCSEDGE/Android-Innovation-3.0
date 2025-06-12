import SwiftUI
import CoreData

struct AIChatView: View {
    let chat: Chat
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var messages: FetchedResults<Message>
    @State private var userInput: String = ""
    @EnvironmentObject var themeManager: ThemeManager
    
    // Initialize with specific chat's messages
    init(chat: Chat) {
        self.chat = chat
        self._messages = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Message.timestamp, ascending: true)],
            predicate: NSPredicate(format: "chat == %@", chat),
            animation: .default
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Display chat messages
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Welcome message if no messages
                    if messages.isEmpty {
                        MessageBubble(content: "Welcome to the RAFI AI Chat!", isUser: false, timestamp: Date())
                    }
                    
                    ForEach(messages, id: \.self) { message in
                        MessageBubble(
                            content: message.content ?? "",
                            isUser: message.isUser,
                            timestamp: message.timestamp ?? Date()
                        )
                    }
                }
                .padding()
            }
            .themedBackground(themeManager.currentTheme)
            
            // Input field and send button
            HStack(spacing: 12) {
                TextField("Type your message", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)
                    .background(themeManager.currentTheme.surfaceColor)
                    .cornerRadius(20)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(themeManager.currentTheme.accentColor)
                }
                .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .themedSurface(themeManager.currentTheme)
        }
        .themedBackground(themeManager.currentTheme)
        .navigationTitle(chat.name ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Save user message to Core Data
        let userMessage = Message(context: viewContext)
        userMessage.content = userInput
        userMessage.isUser = true
        userMessage.timestamp = Date()
        userMessage.chat = chat
        
        let messageContent = userInput
        userInput = ""
        
        // Save to Core Data
        do {
            try viewContext.save()
        } catch {
            print("Error saving user message: \(error)")
        }
        
        // Call the AI API
        callAIAPI(message: messageContent) { response in
            DispatchQueue.main.async {
                // Save AI response to Core Data
                let aiMessage = Message(context: viewContext)
                aiMessage.content = response
                aiMessage.isUser = false
                aiMessage.timestamp = Date()
                aiMessage.chat = chat
                
                do {
                    try viewContext.save()
                } catch {
                    print("Error saving AI message: \(error)")
                }
            }
        }
    }
    
    private func callAIAPI(message: String, completion: @escaping (String) -> Void) {
        // Correct API URL
        let apiUrl = "https://llm.datasaur.ai/api/sandbox/3262/2700/chat/completions"
        let apiKey = "c983501b-a5f1-4cad-bc6a-aa17dfbba48b"
        
        // Prepare the request
        guard let url = URL(string: apiUrl) else {
            completion("Error: Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Correct body structure
        let body: [String: Any] = [
            "messages": [
                ["role": "user", "content": message]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion("Error: Unable to encode request body")
            return
        }
        
        // Debugging: Print the request
        print("API URL: \(apiUrl)")
        print("Request Body: \(body)")
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion("Error: No data received")
                return
            }
            
            // Debugging: Print the raw response
            print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Invalid response")")
            
            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let content = choices.first?["message"] as? [String: Any],
                   let text = content["content"] as? String {
                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    completion("Error: Unexpected API response")
                }
            } catch {
                completion("Error: Failed to parse response")
            }
        }.resume()
    }
}

// MARK: - Updated MessageBubble
struct MessageBubble: View {
    let content: String
    let isUser: Bool
    let timestamp: Date
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            if isUser {
                Spacer()
            }
            
            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                Text(content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        isUser ?
                        themeManager.currentTheme.primaryColor :
                        themeManager.currentTheme.surfaceColor
                    )
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .cornerRadius(20)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: isUser ? .trailing : .leading)
                
                Text(formatTime(timestamp))
                    .font(.caption2)
                    .foregroundColor(themeManager.currentTheme.textColor.opacity(0.6))
                    .padding(.horizontal, 4)
            }
            
            if !isUser {
                Spacer()
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
