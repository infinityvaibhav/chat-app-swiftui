//
//  Message.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//

import Foundation

// MARK: - Message Model
/// The text property is the message typed by user or received from automatic reply
/// The isUser property is crucial for distinguishing between messages sent by the user and messages received
struct Message: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
