//
//  DocuSealError.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

// MARK: - Error Types

public enum DocuSealError: Error {
    case httpError(statusCode: UInt, message: String)
    case decodingError(message: String)
    case encodingError(message: String)
    case invalidURL(url: String)
    case webhookAuthenticationError(message: String)
}

extension DocuSealError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .httpError(let statusCode, let message):
            return "HTTP error \(statusCode): \(message)"
        case .decodingError(let error):
            return "Decoding error: \(error)"
        case .encodingError(let error):
            return "Encoding error: \(error)"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .webhookAuthenticationError(let message):
            return "Webhook authentication error: \(message)"
        }
    }
}
