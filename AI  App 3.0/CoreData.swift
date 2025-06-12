
import SwiftUI
import CoreData


import SwiftUI
import CoreData

@main
struct AI_App_3_0App: App {
    @StateObject private var themeManager = ThemeManager()
    
    // Core Data stack
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
