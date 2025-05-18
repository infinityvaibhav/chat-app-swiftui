//
//  ChatView.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import SwiftUI

// MARK: - View

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        chatWindowView
        footer
    }
    
    /// 1. In the chat window all the sent and recevied message will be displayed
    /// 2. We are also assigning id to every message to identify each of them
    /// 3. We are scrolling to latest message
    @ViewBuilder
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
    
    /// 1. In footer we have TextField to enter message
    /// 2. In Button to send message, we have used 'paperplane' SFsymbol as it is more familiar by users for better User experience.
    @ViewBuilder
    var footer: some View {
        HStack {
            TextField(enterMessage, text: $viewModel.currentMessageText)
                .padding(.vertical, 8)
                .textFieldStyle(.roundedBorder)
            
            Button {
                viewModel.sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.green.cornerRadius(20))
            }
        }
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ChatView(viewModel: ChatViewModel(messageUseCase: MessageUseCase()))
}
