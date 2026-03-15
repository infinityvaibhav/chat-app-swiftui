//
//  ChatView.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import SwiftUI

// MARK: - View

/// The primary view for displaying and interacting with the chat interface.
///
/// This view presents a scrollable list of messages and a footer with input controls for sending new messages.
struct ChatView: View {
    /// The observed view model that provides the chat data and handles user interactions.
    @ObservedObject var viewModel: ChatViewModel
    
    /// The main body of the view, composed of the chat window and footer.
    var body: some View {
        chatWindowView
        footer
    }
    
    /// A view builder that creates the scrollable chat window displaying all messages.
    ///
    /// The chat window uses a LazyVStack for efficient rendering and automatically scrolls to the latest message when new messages are added.
    var chatWindowView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.messages) { message in
                        MessageView(message: message)
                            .id(message.id)
                    }
                }
                .onChange(of: viewModel.messages.last?.id) {
                    
                    /// Scroll to latest message
                    if let lastMessageId = viewModel.messages.last?.id {
                        scrollViewProxy.scrollTo(lastMessageId)
                    }
                }
            }
        }
    }
    
    /// A view builder that creates the footer with a text field for message input and a send button.
    ///
    /// The footer includes a TextField bound to the view model's current message text and a Button that triggers sending the message, with loading state handling.
    @ViewBuilder
    var footer: some View {
        HStack {
            TextField(enterMessage, text: $viewModel.currentMessageText)
                .padding(.vertical, 8)
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.isLoading)
            
            Button {
                viewModel.sendMessage()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .padding(12)
                        .background(Color.green.opacity(0.5).cornerRadius(20))
                } else {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.green.cornerRadius(20))
                }
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
    }
}

/// A preview of the ChatView for design and testing, using a mock view model.
#Preview(traits: .sizeThatFitsLayout) {
    ChatView(viewModel: ChatViewModel(messageUseCase: MessageUseCase()))
}
