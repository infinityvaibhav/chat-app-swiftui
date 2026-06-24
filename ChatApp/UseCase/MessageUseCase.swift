//
//  MessageUseCase.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//
import Foundation
import FoundationModels

// MARK: - Message Use Case Protocol
/// Protocol for message use case operations.
protocol MessageUseCaseProtocol {
    /// Streams a reply to the given user prompt.
    ///
    /// The returned stream emits cumulative content snapshots: each value is the
    /// full reply generated so far, suitable for driving a live "typing" effect.
    /// - Parameter prompt: The user's latest message.
    /// - Returns: An async stream of cumulative reply snapshots.
    func streamReply(to prompt: String) -> AsyncThrowingStream<String, Error>
}

/// Implementation of the message use case.
///
/// When Apple's on-device Foundation Models are available, replies are generated
/// by a `LanguageModelSession` that retains conversation context across turns.
/// Otherwise it falls back to a delayed random canned response.
final class MessageUseCase: MessageUseCaseProtocol {

    /// The on-device session, created lazily and reused to preserve conversation memory.
    private lazy var session = LanguageModelSession(instructions: assistantInstructions)

    /// Whether the on-device model is ready to generate responses right now.
    ///
    /// Logs the reason when unavailable (e.g. device not eligible, Apple Intelligence
    /// not enabled, or the model assets are still downloading) so the fallback path
    /// is easier to diagnose.
    private var isModelAvailable: Bool {
        switch SystemLanguageModel.default.availability {
        case .available:
            return true
        case .unavailable(let reason):
            print("Foundation Models unavailable: \(reason)")
            return false
        @unknown default:
            return false
        }
    }

    func streamReply(to prompt: String) -> AsyncThrowingStream<String, Error> {
        guard isModelAvailable else {
            return fallbackStream()
        }
        return foundationModelStream(for: prompt)
    }

    /// Bridges the Foundation Models response stream into an `AsyncThrowingStream`.
    private func foundationModelStream(for prompt: String) -> AsyncThrowingStream<String, Error> {
        let session = session
        return AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    let responseStream = session.streamResponse(to: prompt)
                    for try await partial in responseStream {
                        continuation.yield(partial.content)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    /// Emits a single delayed random reply when the on-device model is unavailable.
    private func fallbackStream() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                try? await Task.sleep(nanoseconds: fiveSecond)
                continuation.yield(replies.randomElement() ?? "...")
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
