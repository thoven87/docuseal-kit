//
//  DocuSealEntityModel.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/9/25.
//

/// Entity that can be used as signers, submitters e.t.c for embeding UI
/// The token response should be { "token": "JWT", submitters: [DocuSealSubmitterEntityModel] }
/// It'll prefill signers automatically
public struct DocuSealSubmitterEntityModel: Codable, Sendable {
    /// Person or Organization name
    public var name: String
    /// Role of the entity e.g Vender, Customer, Employee e.t.c
    public var role: String?
    /// Email of the entity
    public var email: String?
    /// Phone number of the enity
    public var phone: String?
    /// Your application-specific unique string key
    /// to identify this submitter within your app
    public let externalId: String?
    /// Metadata which can include application metadata
    /// e.g ["tenant_id": "383893", "source": "portal"]
    public var metadata: [String: String]?

    /// Init
    public init(
        name: String,
        role: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        metadata: [String: String]? = nil,
        externalId: String? = nil
    ) {
        self.name = name
        self.role = role
        self.email = email
        self.phone = phone
        self.metadata = metadata
        self.externalId = externalId
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case role
        case email
        case phone
        case metadata
        case externalId = "external_id"
    }
}
