//
//  MessageUseCase.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import Foundation

// MARK: - Message Use Case Protocol
/// Protocol for message use case operations.
protocol MessageUseCaseProtocol {
    /// Simulates a reply to a message asynchronously.
    func simulateReply() async -> String
}

/// Implementation of the message use case for simulating chat replies.
class MessageUseCase: MessageUseCaseProtocol {
    /// Simulates a reply by waiting and returning a random response.
    func simulateReply() async -> String {
        try? await Task.sleep(nanoseconds: fiveSecond) // Simulate 5-second delay
        return replies.randomElement() ?? "..."
    }
}
