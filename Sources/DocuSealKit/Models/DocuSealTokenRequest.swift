//
//  Token.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/8/25.
//

import JWTKit

public struct DocuSealTokenRequest: JWTPayload {
    /// User requesting to sign a document
    let userEmail: String

    /// Integration Email
    let intergrationEmail: String

    /// Request name
    let name: String

    /// Documents
    let documentURLs: [String]

    /// External file or request id
    let externalID: String

    public init(
        externalID: String,
        userEmail: String,
        intergrationEmail: String,
        name: String,
        documentURLs: [String]
    ) {
        self.externalID = externalID
        self.userEmail = userEmail
        self.intergrationEmail = intergrationEmail
        self.name = name
        self.documentURLs = documentURLs
    }

    public func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        // no verifiable claims
    }

    enum CodingKeys: String, CodingKey {
        case externalID = "external_id"
        case userEmail = "user_email"
        case intergrationEmail = "integration_email"
        case name
        case documentURLs = "document_urls"
    }
}
