//
//  Constants.swift
//  ChatApp
//
//  Created by वैभव उपाध्याय on 05/05/25.
//

let enterMessage = "Enter message"

/// Instructions that define the on-device assistant's persona and behavior.
let assistantInstructions = """
You are a friendly and helpful chat assistant. \
Keep your replies concise, clear, and conversational. \
Respond directly to the user's most recent message while keeping the \
context of the ongoing conversation in mind.
"""

/// Fallback replies used when the on-device model is unavailable.
let replies = [
    "Hello there!",
    "Got it.",
    "Interesting...",
    "How can I help you further?",
    "That's noted."
]

let fiveSecond: UInt64 = 5_000_000_000
