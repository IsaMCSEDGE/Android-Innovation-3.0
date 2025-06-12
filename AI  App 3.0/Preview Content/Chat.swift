import Foundation
import CoreData

@objc(Chat)
public class Chat: NSManagedObject {
    
}

extension Chat {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var messages: NSSet?
}

// MARK: Generated accessors for messages
extension Chat {
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)
    
    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)
    
    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)
    
    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
}