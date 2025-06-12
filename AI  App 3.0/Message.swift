//
//  Message.swift
//  AI  App 3.0
//
//  Created by Isa Muniz on 6/12/25.
//


import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    
}

extension Message {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }
    
    @NSManaged public var content: String?
    @NSManaged public var isUser: Bool
    @NSManaged public var timestamp: Date?
    @NSManaged public var chat: Chat?
}