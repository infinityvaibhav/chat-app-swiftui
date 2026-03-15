//
//  ContentView.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//

import SwiftUI

/// The main view of the ChatApp, serving as the root view of the application.
///
/// This view initializes the chat view model and presents the chat interface.
struct ContentView: View {
    
    /// The view model managing the chat functionality and state.
    @StateObject var chatViewModel: ChatViewModel = ChatViewModel(messageUseCase: MessageUseCase())
    
    /// The body of the view, displaying the chat interface.
    var body: some View {
        ChatView(viewModel: chatViewModel)
    }
}

/// A preview of the ContentView for design and testing in Xcode's canvas.
#Preview {
    ContentView()
}
