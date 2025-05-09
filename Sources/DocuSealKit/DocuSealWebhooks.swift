//
//  DocuSealWebhooks.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation
import NIOFoundationCompat

public enum DocuSealWebhookEventType: String, Codable {
    // Form Webhooks
    case formViewed = "form.viewed"
    case formStarted = "form.started"
    case formCompleted = "form.completed"
    case formDeclined = "form.declined"

    // Submission Webhooks
    case submissionCreated = "submission.created"
    case submissionArchived = "submission.archived"
    case submissionCompleted = "submission.completed"
    case submissionExpired = "submission.expired"

    // Template Webhooks
    case templateCreated = "template.created"
    case templateUpdated = "template.updated"
}

// MARK: - Base Webhook Event

public struct DocuSealWebhookEvent<T: Codable>: Codable {
    public let eventType: DocuSealWebhookEventType
    public let timestamp: Date
    public let data: T

    public init(eventType: DocuSealWebhookEventType, timestamp: Date, data: T) {
        self.eventType = eventType
        self.timestamp = timestamp
        self.data = data
    }

    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case timestamp
        case data
    }
}

// MARK: - Form Webhook Data

public struct DocuSealFormWebhookData: Codable {
    public let id: Int
    public let submissionId: Int
    public let email: String?
    public let ua: String?
    public let ip: String?
    public let name: String?
    public let phone: String?
    public let role: String?
    public let externalId: String?
    public let applicationKey: String?
    public let declineReason: String?
    public let sentAt: Date?
    public let status: String
    public let openedAt: Date?
    public let completedAt: Date?
    public let declinedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    public let submission: DocuSealFormSubmissionInfo?
    public let template: TemplateReference?
    public let preferences: [String: AnyCodable]?
    public let values: [FieldValue]?
    public let metadata: [String: AnyCodable]?
    public let auditLogUrl: String?
    public let submissionUrl: String?
    public let documents: [Document]?

    public init(
        id: Int,
        submissionId: Int,
        email: String?,
        ua: String?,
        ip: String?,
        name: String?,
        phone: String?,
        role: String?,
        externalId: String?,
        applicationKey: String?,
        declineReason: String?,
        sentAt: Date?,
        status: String,
        openedAt: Date?,
        completedAt: Date?,
        declinedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        submission: DocuSealFormSubmissionInfo?,
        template: TemplateReference?,
        preferences: [String: AnyCodable]?,
        values: [FieldValue]?,
        metadata: [String: AnyCodable]?,
        auditLogUrl: String?,
        submissionUrl: String?,
        documents: [Document]?
    ) {
        self.id = id
        self.submissionId = submissionId
        self.email = email
        self.ua = ua
        self.ip = ip
        self.name = name
        self.phone = phone
        self.role = role
        self.externalId = externalId
        self.applicationKey = applicationKey
        self.declineReason = declineReason
        self.sentAt = sentAt
        self.status = status
        self.openedAt = openedAt
        self.completedAt = completedAt
        self.declinedAt = declinedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.submission = submission
        self.template = template
        self.preferences = preferences
        self.values = values
        self.metadata = metadata
        self.auditLogUrl = auditLogUrl
        self.submissionUrl = submissionUrl
        self.documents = documents
    }

    enum CodingKeys: String, CodingKey {
        case id
        case submissionId = "submission_id"
        case email
        case ua
        case ip
        case name
        case phone
        case role
        case externalId = "external_id"
        case applicationKey = "application_key"
        case declineReason = "decline_reason"
        case sentAt = "sent_at"
        case status
        case openedAt = "opened_at"
        case completedAt = "completed_at"
        case declinedAt = "declined_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case submission
        case template
        case preferences
        case values
        case metadata
        case auditLogUrl = "audit_log_url"
        case submissionUrl = "submission_url"
        case documents
    }
}

public struct DocuSealFormSubmissionInfo: Codable {
    public let id: Int
    public let auditLogUrl: String?
    public let combinedDocumentUrl: String?
    public let status: String
    public let url: String?
    public let createdAt: Date

    public init(
        id: Int,
        auditLogUrl: String?,
        combinedDocumentUrl: String?,
        status: String,
        url: String?,
        createdAt: Date
    ) {
        self.id = id
        self.auditLogUrl = auditLogUrl
        self.combinedDocumentUrl = combinedDocumentUrl
        self.status = status
        self.url = url
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case auditLogUrl = "audit_log_url"
        case combinedDocumentUrl = "combined_document_url"
        case status
        case url
        case createdAt = "created_at"
    }
}

// MARK: - Submission Webhook Data

public struct DocuSealSubmissionWebhookData: Codable {
    public let id: Int
    public let archivedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    public let source: String
    public let submittersOrder: String
    public let auditLogUrl: String?
    public let submitters: [Submitter]
    public let template: TemplateReference?
    public let createdByUser: UserReference?
    public let webhookEvents: [DocuSealWebhookSubmissionEvent]?
    public let documents: [Document]?
    public let status: String
    public let completedAt: Date?

    public init(
        id: Int,
        archivedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        source: String,
        submittersOrder: String,
        auditLogUrl: String?,
        submitters: [Submitter],
        template: TemplateReference?,
        createdByUser: UserReference?,
        webhookEvents: [DocuSealWebhookSubmissionEvent]?,
        documents: [Document]?,
        status: String,
        completedAt: Date?
    ) {
        self.id = id
        self.archivedAt = archivedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.source = source
        self.submittersOrder = submittersOrder
        self.auditLogUrl = auditLogUrl
        self.submitters = submitters
        self.template = template
        self.createdByUser = createdByUser
        self.webhookEvents = webhookEvents
        self.documents = documents
        self.status = status
        self.completedAt = completedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case archivedAt = "archived_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case source
        case submittersOrder = "submitters_order"
        case auditLogUrl = "audit_log_url"
        case submitters
        case template
        case createdByUser = "created_by_user"
        case webhookEvents = "submission_events"
        case documents
        case status
        case completedAt = "completed_at"
    }
}

public struct DocuSealWebhookSubmissionEvent: Codable {
    public let id: Int
    public let submitterId: Int
    public let eventType: String
    public let eventTimestamp: Date

    public init(id: Int, submitterId: Int, eventType: String, eventTimestamp: Date) {
        self.id = id
        self.submitterId = submitterId
        self.eventType = eventType
        self.eventTimestamp = eventTimestamp
    }

    enum CodingKeys: String, CodingKey {
        case id
        case submitterId = "submitter_id"
        case eventType = "event_type"
        case eventTimestamp = "event_timestamp"
    }
}

// MARK: - Template Webhook Data

public struct DocuSealTemplateWebhookData: Codable {
    public let id: Int
    public let slug: String
    public let name: String
    public let schema: [TemplateSchema]
    public let fields: [TemplateField]
    public let submitters: [TemplateSubmitter]
    public let authorId: Int
    public let accountId: Int?
    public let archivedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    public let source: String
    public let folderId: Int?
    public let externalId: String?
    public let preferences: [String: AnyCodable]?
    public let applicationKey: String?
    public let folderName: String?
    public let author: UserReference
    public let documents: [TemplateDocument]

    public init(
        id: Int,
        slug: String,
        name: String,
        schema: [TemplateSchema],
        fields: [TemplateField],
        submitters: [TemplateSubmitter],
        authorId: Int,
        accountId: Int?,
        archivedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        source: String,
        folderId: Int?,
        externalId: String?,
        preferences: [String: AnyCodable]?,
        applicationKey: String?,
        folderName: String?,
        author: UserReference,
        documents: [TemplateDocument]
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.schema = schema
        self.fields = fields
        self.submitters = submitters
        self.authorId = authorId
        self.accountId = accountId
        self.archivedAt = archivedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.source = source
        self.folderId = folderId
        self.externalId = externalId
        self.preferences = preferences
        self.applicationKey = applicationKey
        self.folderName = folderName
        self.author = author
        self.documents = documents
    }

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case schema
        case fields
        case submitters
        case authorId = "author_id"
        case accountId = "account_id"
        case archivedAt = "archived_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case source
        case folderId = "folder_id"
        case externalId = "external_id"
        case preferences
        case applicationKey = "application_key"
        case folderName = "folder_name"
        case author
        case documents
    }
}

// MARK: - Typealias for Webhook Events

public typealias DocuSealFormEvent = DocuSealWebhookEvent<DocuSealFormWebhookData>
public typealias DocuSealSubmissionWebhookEvent = DocuSealWebhookEvent<
    DocuSealSubmissionWebhookData
>
public typealias DocuSealTemplateEvent = DocuSealWebhookEvent<DocuSealTemplateWebhookData>

// MARK: - Webhook Handler

public struct DocusealWebhookHandler {
    /// Verify if the webhook request signature is valid (verify that the request came from DocuSeal)
    public static func verifySignature(
        requestBody: Data,
        signatureHeader: String,
        webhookSecret: String
    ) -> Bool {
        // DocuSeal doesn't currently provide a specific signature verification mechanism
        // This method is prepared for future implementation
        // For now, return true but can be enhanced when DocuSeal adds signature verification
        true
    }

    /// Verify if the webhook request credentials are valid (verify that the request came from DocuSeal)
    public static func verifyCredentials(
        key: String,
        value: String
    ) -> Bool {
        key == value
    }

    /// Parse the webhook event from the request body
    public static func parseWebhookEvent(
        from data: Data
    ) throws -> (
        type: DocuSealWebhookEventType, payload: Data
    ) {
        // First parse just to get the event type
        struct EventTypeContainer: Codable {
            let eventType: String

            enum CodingKeys: String, CodingKey {
                case eventType = "event_type"
            }
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let eventTypeContainer = try decoder.decode(EventTypeContainer.self, from: data)
        guard let eventType = DocuSealWebhookEventType(rawValue: eventTypeContainer.eventType) else {
            throw DocuSealError.decodingError(
                message: "DocusealWebhookHandler -> Invalid event type: \(eventTypeContainer.eventType)"
            )
        }

        return (type: eventType, payload: data)
    }

    /// Process form webhook events
    public static func processFormEvent(data: Data) throws -> DocuSealFormEvent {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(DocuSealFormEvent.self, from: data)
    }

    /// Process submission webhook events
    public static func processSubmissionEvent(data: Data) throws -> DocuSealSubmissionWebhookEvent {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(DocuSealSubmissionWebhookEvent.self, from: data)
    }

    /// Process template webhook events
    public static func processTemplateEvent(data: Data) throws -> DocuSealTemplateEvent {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(DocuSealTemplateEvent.self, from: data)
    }
}
