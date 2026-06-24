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

    /// Sends the current message and streams the assistant's reply.
    ///
    /// This method creates a user message, adds it to the chat, clears the input,
    /// sets the loading state, and asynchronously streams a reply from the use case,
    /// updating the in-progress bot message in place as content arrives.
    func sendMessage() {
        guard !currentMessageText.isEmpty else { return }
        let userMessage = Message(text: currentMessageText, isUser: true)
        messages.append(userMessage)
        let textToSend = currentMessageText
        currentMessageText = ""
        isLoading = true

        // Placeholder bot message that gets filled in as the stream emits snapshots.
        let botMessage = Message(text: "", isUser: false)
        messages.append(botMessage)
        let botMessageID = botMessage.id

        Task {
            defer { isLoading = false }
            do {
                for try await snapshot in messageUseCase.streamReply(to: textToSend) {
                    updateMessage(id: botMessageID, text: snapshot)
                }
            } catch {
                updateMessage(id: botMessageID, text: replies.randomElement() ?? "...")
            }
        }
    }

    /// Replaces the text of the message with the given identifier, if it still exists.
    private func updateMessage(id: UUID, text: String) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].text = text
    }
}
