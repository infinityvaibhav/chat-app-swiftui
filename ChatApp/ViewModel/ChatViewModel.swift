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

    private let messageUseCase: MessageUseCaseProtocol

    init(messageUseCase: MessageUseCaseProtocol) {
        self.messageUseCase = messageUseCase
    }

    /// 1. Checks if there's any text to send.
    /// 2. Creates a user message and adds it to the chat log.
    /// 3. Clears the input text field.
    /// 4.Initiates an asynchronous task to simulate a reply.
    /// 5. Waits for the simulated reply.
    /// 6. Creates a bot message with the reply and adds it to the chat log.
    func sendMessage() {
        guard !currentMessageText.isEmpty else { return }
        let userMessage = Message(text: currentMessageText, isUser: true)
        messages.append(userMessage)
        currentMessageText = ""

        Task {
            let reply = await messageUseCase.simulateReply()
            messages.append(Message(text: reply, isUser: false))
        }
    }
}
