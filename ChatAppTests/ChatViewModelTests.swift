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
    /// Optional intermediate snapshots emitted before the final reply, to mimic streaming.
    var streamedSnapshots: [String]?

    func streamReply(to prompt: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                if delay > 0 {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
                for snapshot in streamedSnapshots ?? [] {
                    continuation.yield(snapshot)
                }
                continuation.yield(simulatedReply)
                continuation.finish()
            }
        }
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

        // User message plus an empty placeholder for the streamed bot reply.
        #expect(viewModel.messages.count == 2, "User message and bot placeholder should be added")
        #expect(viewModel.messages[0].text == "Hello, world!", "Message text should match input")
        #expect(viewModel.messages[0].isUser == true, "Message should be from user")
        #expect(viewModel.messages[1].isUser == false, "Placeholder should be a bot message")
        #expect(viewModel.currentMessageText.isEmpty, "Input text should be cleared")
    }

    @Test("Sending an empty message does not add it to the messages array")
    func testSendMessage_emptyMessageDoesNotAdd() async {
        viewModel.currentMessageText = ""
        viewModel.sendMessage()
        #expect(viewModel.messages.isEmpty, "Empty message should not be added")
    }

    @Test("streamReply emits the final reply")
    func testStreamReply_returnsCorrectReply() async throws {
        mockUseCase.simulatedReply = "Expected Reply"
        var lastSnapshot: String?
        for try await snapshot in mockUseCase.streamReply(to: "Question") {
            lastSnapshot = snapshot
        }
        #expect(lastSnapshot == "Expected Reply", "Final snapshot should match simulatedReply")
    }

    @Test("streamReply emits cumulative snapshots in order")
    func testStreamReply_emitsSnapshotsInOrder() async throws {
        mockUseCase.streamedSnapshots = ["He", "Hello"]
        mockUseCase.simulatedReply = "Hello there"
        var snapshots: [String] = []
        for try await snapshot in mockUseCase.streamReply(to: "Hi") {
            snapshots.append(snapshot)
        }
        #expect(snapshots == ["He", "Hello", "Hello there"], "Snapshots should arrive in order")
    }

    @Test("streamReply waits for the specified delay")
    func testStreamReply_waitsForDelay() async throws {
        mockUseCase.simulatedReply = "Delayed Reply"
        mockUseCase.delay = 2 // Set a 2-second delay
        let startTime = CFAbsoluteTimeGetCurrent()
        var reply: String?
        for try await snapshot in mockUseCase.streamReply(to: "Question") {
            reply = snapshot
        }
        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime

        #expect(reply == "Delayed Reply", "Reply should match simulatedReply")
        #expect(elapsedTime >= 2, "Should wait for at least 2 seconds")
    }
    
    @Test("Sending a message triggers a reply and adds it to messages")
    func testSendMessage_triggersReply() async throws {
        mockUseCase.simulatedReply = "Bot Response"
        viewModel.currentMessageText = "User Question"
        viewModel.sendMessage()
        
        // Wait for the streamed reply to complete
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 second
        
        #expect(viewModel.messages.count == 2, "Should have user message and bot reply")
        #expect(viewModel.messages[1].text == "Bot Response", "Bot reply should match")
        #expect(viewModel.messages[1].isUser == false, "Bot message should not be from user")
    }
}
