## Overview

This project is a basic chat application demonstrating a simple messaging interface. 
It's built using Swift and SwiftUI, and incorporates the MVVM architecture pattern along with elements of Clean Architecture. 
The app allows users to send text messages, and simulates a delayed response from a "bot."

## Features

* **Message Sending:** Users can type a text message and send it.
* **Message Display:** Sent messages are displayed on the right side of the chat interface.
* **Simulated Reply:** The app simulates a 5-second delay and then displays a reply message on the left side.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture, with influences from Clean Architecture:

* **Model:** The `Message` struct represents the data for a single chat message.
* **View:**
    * `ChatView` is the main view that displays the chat interface.
    * `MessageView` is responsible for displaying individual messages.
* **ViewModel:** `ChatViewModel` manages the state and logic for the chat view. It handles sending messages and receiving simulated replies.
* **Use Case (Interactor):** `MessageUseCase` (and `MessageUseCaseProtocol`) defines the business logic for simulating replies. This adheres to Clean Architecture principles by separating the core logic from the UI and state management.

## Technical Details

* **Language:** Swift
* **UI Framework:** SwiftUI
* **Architecture:** MVVM, with elements of Clean Architecture
* **Concurrency:** `async/await`
* **Testing:** XCTest (with a mock use case for isolated testing)

## Code Structure

* `Message.swift`: Defines the `Message` model.
* `ChatViewModel.swift`: Contains the `ChatViewModel` class.
* `MessageUseCase.swift`: Contains the `MessageUseCase` and `MessageUseCaseProtocol`.
* `ChatView.swift`: Contains the `ChatView` and `MessageView` structs.
* `ContentView.swift`:  The entry point of the application; sets up and injects the dependencies.
* `ChatViewModelTests.swift`: Contains the XCTest unit tests for `ChatViewModel` and `MessageUseCase`.

## Testing

The project includes unit tests for the `ChatViewModel` and `MessageUseCase`.  The tests use a `MockMessageUseCase` to isolate the view model from the actual reply simulation, allowing for more controlled and predictable testing.

To run the tests:

1.  Open the project in Xcode.
2.  Go to the Testing navigator (Command + 9).
3.  Select the test target.
4.  Click the "Run" button.

## Future Enhancements

* Implement a real backend for message persistence and retrieval.
* Add support for multiple chat participants.
* Implement a more sophisticated reply generation mechanism.
* Add UI improvements, such as message threading, user avatars, and typing indicators.
* Add error handling and edge case management.
    
