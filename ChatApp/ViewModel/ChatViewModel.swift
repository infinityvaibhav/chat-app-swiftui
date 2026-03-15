//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import Foundation
import Combine

// MARK: - View Model
/// Mark the ViewModel with MainActor to run on the main actor for UI updates
@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentMessageText: String = ""
    @Published var isLoading: Bool = false

    private let messageUseCase: MessageUseCaseProtocol

    init(messageUseCase: MessageUseCaseProtocol) {
        self.messageUseCase = messageUseCase
    }

    /// Sends the current message and simulates a reply.
    ///
    /// This method creates a user message, adds it to the chat, clears the input, sets loading state, and asynchronously fetches a simulated reply.
    func sendMessage() {
        guard !currentMessageText.isEmpty else { return }
        let userMessage = Message(text: currentMessageText, isUser: true)
        messages.append(userMessage)
        let textToSend = currentMessageText
        currentMessageText = ""
        isLoading = true

        Task {
            let reply = await messageUseCase.simulateReply()
            messages.append(Message(text: reply, isUser: false))
            isLoading = false
        }
    }
}
