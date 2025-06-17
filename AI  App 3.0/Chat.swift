//
//  Chat.swift
//  AI  App 3.0
//
//  Created by Isa Muniz on 6/12/25.
//


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

//Accessors for messages
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