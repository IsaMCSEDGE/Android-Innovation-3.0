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
// 
extension Message {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }
    // Confirms that the users and ai messages are separate
    @NSManaged public var content: String? //Makes sure that its recieving a message.
    @NSManaged public var isUser: Bool // Checks if it is the user (true) or the ai (false)
    @NSManaged public var timestamp: Date?// Checks to see what the date is
    @NSManaged public var chat: Chat? // Checks to see "Is this the right chat?"
}