//
//  ChatViewModelTests.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import XCTest
@testable import ChatApp

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

@MainActor
class ChatViewModelTests: XCTestCase {

    var mockUseCase: MockMessageUseCase!
    var viewModel: ChatViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockMessageUseCase()
        viewModel = ChatViewModel(messageUseCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    // Test that sending a message adds it to the messages array and clears the input text.
    func testSendMessage_addsMessageAndClearsInput() async {
        viewModel.currentMessageText = "Hello, world!"
        viewModel.sendMessage()

        XCTAssertEqual(viewModel.messages.count, 1, "Message should be added to messages array")
        XCTAssertEqual(viewModel.messages[0].text, "Hello, world!", "Message text should match input")
        XCTAssertTrue(viewModel.messages[0].isUser, "Message should be from user")
        XCTAssertTrue(viewModel.currentMessageText.isEmpty, "Input text should be cleared")
    }

    // Test that sending an empty message does not add it to the messages array.
    func testSendMessage_emptyMessageDoesNotAdd() async {
        viewModel.currentMessageText = ""
        viewModel.sendMessage()
        XCTAssertTrue(viewModel.messages.isEmpty, "Empty message should not be added")
    }

    // Test that simulateReply in use case returns the correct reply.
    func testSimulateReply_returnsCorrectReply() async {
        mockUseCase.simulatedReply = "Expected Reply"
        let reply = await mockUseCase.simulateReply()
        XCTAssertEqual(reply, "Expected Reply", "Reply should match simulatedReply")
    }

    // Test that simulateReply in use case waits for the specified delay.
    func testSimulateReply_waitsForDelay() async {
        mockUseCase.simulatedReply = "Delayed Reply"
        mockUseCase.delay = 2 // Set a 2-second delay
        let startTime = CFAbsoluteTimeGetCurrent()
        let reply = await mockUseCase.simulateReply()
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = endTime - startTime

        XCTAssertEqual(reply, "Delayed Reply", "Reply should match simulatedReply")
        XCTAssertGreaterThanOrEqual(elapsedTime, 2, "Should wait for at least 2 seconds")
    }
    
    // Test that sending a message triggers a reply from the use case and adds it to messages
    func testSendMessage_triggersReply() async {
        mockUseCase.simulatedReply = "Bot Response"
        viewModel.currentMessageText = "User Question"
        viewModel.sendMessage()
        
        // Wait for the reply.  Since we're in a test, we can use a short delay or
        // a more robust method like fulfilling an expectation.  For simplicity, I'll use a short delay.
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        XCTAssertEqual(viewModel.messages.count, 2) // User message + Bot reply
        XCTAssertEqual(viewModel.messages[1].text, "Bot Response")
        XCTAssertFalse(viewModel.messages[1].isUser)
    }
}
