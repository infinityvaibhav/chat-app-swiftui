//
//  ChatViewModelTests.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import Testing
@testable import ChatApp
import Foundation

// MARK: - Mock Use Case for Testing

// Create a mock MessageUseCase that allows us to control the reply for testing purposes.
class MockMessageUseCase: MessageUseCaseProtocol {
    var simulatedReply: String = "Test Reply"
    var delay: TimeInterval = 0 // Add a delay property for testing

    func simulateReply() async -> String {
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        return simulatedReply
    }
}

// MARK: - ChatViewModel Tests

@Suite("ChatViewModel Tests")
@MainActor
struct ChatViewModelTests {
    var mockUseCase: MockMessageUseCase
    var viewModel: ChatViewModel

    init() async throws {
        mockUseCase = MockMessageUseCase()
        viewModel = ChatViewModel(messageUseCase: mockUseCase)
    }

    @Test("Sending a message adds it to messages and clears input")
    func testSendMessage_addsMessageAndClearsInput() async {
        viewModel.currentMessageText = "Hello, world!"
        viewModel.sendMessage()

        #expect(viewModel.messages.count == 1, "Message should be added to messages array")
        #expect(viewModel.messages[0].text == "Hello, world!", "Message text should match input")
        #expect(viewModel.messages[0].isUser == true, "Message should be from user")
        #expect(viewModel.currentMessageText.isEmpty, "Input text should be cleared")
    }

    @Test("Sending an empty message does not add it to the messages array")
    func testSendMessage_emptyMessageDoesNotAdd() async {
        viewModel.currentMessageText = ""
        viewModel.sendMessage()
        #expect(viewModel.messages.isEmpty, "Empty message should not be added")
    }

    @Test("SimulateReply returns the correct reply")
    func testSimulateReply_returnsCorrectReply() async {
        mockUseCase.simulatedReply = "Expected Reply"
        let reply = await mockUseCase.simulateReply()
        #expect(reply == "Expected Reply", "Reply should match simulatedReply")
    }

    @Test("SimulateReply waits for the specified delay")
    func testSimulateReply_waitsForDelay() async {
        mockUseCase.simulatedReply = "Delayed Reply"
        mockUseCase.delay = 2 // Set a 2-second delay
        let startTime = CFAbsoluteTimeGetCurrent()
        let reply = await mockUseCase.simulateReply()
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = endTime - startTime

        #expect(reply == "Delayed Reply", "Reply should match simulatedReply")
        #expect(elapsedTime >= 2, "Should wait for at least 2 seconds")
    }
    
    @Test("Sending a message triggers a reply and adds it to messages")
    func testSendMessage_triggersReply() async throws {
        mockUseCase.simulatedReply = "Bot Response"
        viewModel.currentMessageText = "User Question"
        viewModel.sendMessage()
        
        // Wait for the reply
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        #expect(viewModel.messages.count == 2, "Should have user message and bot reply")
        #expect(viewModel.messages[1].text == "Bot Response", "Bot reply should match")
        #expect(viewModel.messages[1].isUser == false, "Bot message should not be from user")
    }
}
