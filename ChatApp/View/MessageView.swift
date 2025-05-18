//
//  MessageView.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import SwiftUI

struct MessageView: View {
    let message: Message

    var body: some View {
        HStack {
            
            /// 1. If message is type from the user then display it in the trailing
            /// 2. If we are receiving the message then display it in leading position
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

/// Added trait 'sizeThatFitsLayout' to only view how message will display
#Preview(traits: .sizeThatFitsLayout) {
    let message = Message(text: "Hello", isUser: true)
    MessageView(message:  message)
}
