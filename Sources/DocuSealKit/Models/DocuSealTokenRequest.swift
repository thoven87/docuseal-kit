//
//  Token.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/8/25.
//

import JWTKit

public struct DocuSealTokenRequest: JWTPayload {
    /// Email address of the DocuSeal admin user that provided the API_KEY for JWT signing.
    let userEmail: String

    /// Email address of your SaaS user that opens the document form builder.
    let intergrationEmail: String

    /// New template name when creating a template with document_urls specified.
    let name: String

    /// An array with public and downloadable document URLs to be opened in the form builder.
    /// Pass empty array to allow users to upload their files.
    let documentURLs: [String]

    /// Unique string to tag the opened document within the DocuSeal platform and to be able to reopen the form using this unique key.
    let externalID: String
    
    /// ID of the existing template to open in the form builder - leave empty if `documents_urls[]` is specified.
    /// Templates can be created via the HTML API or PDF export API.
    var templateID: Int?

    /// The folder name in which the template should be created.
    var folderName: String

    /// Pass `false` to disable automatic PDF form fields extraction.
    /// PDF fields are automatically added by default.
    var extractFields: Bool?
    
    /// DocuSealTokenRequest Instance
    /// - Parameters:
    ///   - externalID: Unique string to tag the opened document within the DocuSeal platform and to be able to reopen the form using this unique key.
    ///   - userEmail: Email address of the DocuSeal admin user that provided the API_KEY for JWT signing.
    ///   - intergrationEmail: Email address of your SaaS user that opens the document form builder.
    ///   - templateName: New template name when creating a template with document_urls specified.
    ///   - documentURLs: An array with public and downloadable document URLs to be opened in the form builder. Pass empty array to allow users to upload their files.
    ///   - templateID: ID of the existing template to open in the form builder - leave empty if `documents_urls[]` is specified. Templates can be created via the HTML API or PDF export API.
    ///   - folderName: The folder name in which the template should be created.
    ///   - extractFields: Pass `false` to disable automatic PDF form fields extraction. PDF fields are automatically added by default.
    public init(
        externalID: String,
        userEmail: String,
        intergrationEmail: String,
        templateName: String,
        documentURLs: [String],
        templateID: Int? = nil,
        folderName: String = "",
        extractFields: Bool? = nil
    ) {
        self.externalID = externalID
        self.userEmail = userEmail
        self.intergrationEmail = intergrationEmail
        self.name = templateName
        self.documentURLs = documentURLs
        self.templateID = templateID
        self.folderName = folderName
        self.extractFields = extractFields
    }

    /// NOOP
    public func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        // no verifiable claims
    }

    enum CodingKeys: String, CodingKey {
        case externalID = "external_id"
        case userEmail = "user_email"
        case intergrationEmail = "integration_email"
        case name
        case documentURLs = "document_urls"
        case templateID = "template_id"
        case folderName = "folder_name"
        case extractFields = "extract_fields"
    }
}
