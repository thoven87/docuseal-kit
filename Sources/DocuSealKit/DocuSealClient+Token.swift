//
//  DocuSealClient+Token.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/8/25.
//

import JWTKit

extension DocuSealClient {
    /// create a token to make requests to docuseal
    public func createToken(_ input: DocuSealTokenRequest) async throws -> String {
        try await keys.sign(input)
    }
}
