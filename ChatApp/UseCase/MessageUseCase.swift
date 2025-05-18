//
//  MessageUseCase.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import Foundation

// MARK: - Message Use Case Protocol
protocol MessageUseCaseProtocol {
    func simulateReply() async -> String
}

class MessageUseCase: MessageUseCaseProtocol {
    func simulateReply() async -> String {
        try? await Task.sleep(nanoseconds: fiveSecond) // Simulate 5-second delay
        return replies.randomElement() ?? "..."
    }
}
