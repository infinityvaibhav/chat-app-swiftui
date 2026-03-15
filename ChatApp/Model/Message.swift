//
//  Message.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//

import Foundation

// MARK: - Message Model
/// A model representing a chat message in the application.
///
/// This struct encapsulates the content of a message, whether it was sent by the user,
/// and provides a unique identifier for use in SwiftUI views.
struct Message: Identifiable {
    /// A unique identifier for the message, automatically generated as a UUID.
    let id = UUID()
    /// The textual content of the message.
    let text: String
    /// A boolean indicating whether the message was sent by the user (`true`) or received (`false`).
    let isUser: Bool
}
