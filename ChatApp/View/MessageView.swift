//
//  MessageView.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import SwiftUI

/// A view that displays a single chat message with appropriate styling and alignment.
///
/// The message is styled differently based on whether it was sent by the user or received.
struct MessageView: View {
    /// The message to display.
    let message: Message

    /// The body of the view, rendering the message text with conditional styling and alignment.
    var body: some View {
        Text(message.text)
            .padding()
            .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(message.isUser ? .white : .black)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
            .padding(.horizontal)
            .padding(.vertical, 4)
    }
}

/// A preview of the MessageView for a user-sent message.
#Preview(traits: .sizeThatFitsLayout) {
    let message = Message(text: "Hello", isUser: true)
    MessageView(message:  message)
}
