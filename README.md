## Overview

This project is a basic chat application demonstrating a simple messaging interface. 
It's built using Swift and SwiftUI, and incorporates the MVVM architecture pattern along with elements of Clean Architecture. 
The app allows users to send text messages and receives replies generated **on-device** by Apple's [Foundation Models](https://developer.apple.com/documentation/foundationmodels) framework, with a graceful fallback to canned replies when the model is unavailable.

## Features

* **Message Sending:** Users can type a text message and send it.
* **Message Display:** Sent messages are displayed on the right side of the chat interface.
* **On-Device AI Replies:** Replies are generated locally by Apple's Foundation Models (`SystemLanguageModel` / `LanguageModelSession`) — no network or backend required.
* **Streaming "Typing" Effect:** Replies stream into the UI token-by-token using cumulative content snapshots.
* **Conversation Memory:** A single `LanguageModelSession` is reused so the assistant retains context across turns.
* **Helpful-Assistant Persona:** The session is configured with instructions defining a concise, friendly assistant.
* **Graceful Fallback:** When the model is unavailable (ineligible device, Apple Intelligence disabled, assets still downloading), the app logs the reason and falls back to a delayed random canned reply.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture, with influences from Clean Architecture:

* **Model:** The `Message` struct represents the data for a single chat message.
* **View:**
    * `ChatView` is the main view that displays the chat interface.
    * `MessageView` is responsible for displaying individual messages.
* **ViewModel:** `ChatViewModel` manages the state and logic for the chat view. It sends messages, appends a placeholder bot message, and updates it in place as streamed reply snapshots arrive.
* **Use Case (Interactor):** `MessageUseCase` (and `MessageUseCaseProtocol`) defines the business logic for generating replies. It checks `SystemLanguageModel.default.availability`, streams responses from a `LanguageModelSession`, and bridges them into an `AsyncThrowingStream`. This adheres to Clean Architecture principles by separating the core logic from the UI and state management.

## Requirements

* **Xcode 26** (iOS 26 SDK) or later.
* **Minimum deployment target: iOS 26.**
* **Apple Intelligence-capable device** for real on-device generation (iPhone 15 Pro / A17 Pro or newer, or an M-series device). On ineligible devices (e.g. iPhone 11) or the Simulator without model assets, the app automatically uses the canned-reply fallback.
* Apple Intelligence must be enabled in Settings and the model finished downloading.

## Technical Details

* **Language:** Swift
* **UI Framework:** SwiftUI
* **On-Device AI:** Foundation Models (`FoundationModels` framework — `SystemLanguageModel`, `LanguageModelSession`, streaming responses)
* **Architecture:** MVVM, with elements of Clean Architecture
* **Concurrency:** `async/await`, `AsyncThrowingStream`
* **Testing:** Swift Testing (with a mock use case for isolated testing)

## Code Structure

* `Message.swift`: Defines the `Message` model (mutable `text` so streamed replies update in place).
* `ChatViewModel.swift`: Contains the `ChatViewModel` class; consumes the reply stream and updates the bot message.
* `MessageUseCase.swift`: Contains the `MessageUseCase` and `MessageUseCaseProtocol`; integrates Foundation Models and the fallback stream.
* `Constants.swift`: Holds the assistant persona instructions and the fallback replies.
* `ChatView.swift`: Contains the `ChatView` and `MessageView` structs.
* `ContentView.swift`:  The entry point of the application; sets up and injects the dependencies.
* `ChatViewModelTests.swift`: Contains the unit tests for `ChatViewModel` and `MessageUseCase`.

## Testing

The project includes unit tests for the `ChatViewModel` and `MessageUseCase`. The tests use a `MockMessageUseCase` that emits a controllable `AsyncThrowingStream` to isolate the view model from the real on-device model, allowing for controlled and predictable testing of both the streaming and final-reply behavior.

To run the tests:

1.  Open the project in Xcode.
2.  Go to the Testing navigator (Command + 9).
3.  Select the test target.
4.  Click the "Run" button.

## Future Enhancements

* Persist conversation history across app launches.
* Add support for multiple chat participants.
* Surface a clear in-UI indicator when running in fallback mode (model unavailable).
* Use `@Generable` structured outputs or tool calling for richer model responses.
* Add UI improvements, such as message threading, user avatars, and typing indicators.
* Expand error handling and edge case management.
    
