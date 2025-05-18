//
//  ContentView.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var chatViewModel: ChatViewModel = ChatViewModel(messageUseCase: MessageUseCase())
    
    var body: some View {
        ChatView(viewModel: chatViewModel)
    }
}

#Preview {
    ContentView()
}
