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

// The status of the submission.
public enum DocuSealSubmissionStatus: String, Codable {
    case awaiting
    case completed
    case declined
    case failed
    case opened
    case sent
}

// MARK: - Base Webhook Event

public struct DocuSealWebhookEvent<T: Codable>: Codable {
    /// 
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
    public let status: DocuSealSubmissionStatus
    public let openedAt: Date?
    public let completedAt: Date?
    public let declinedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    public let submission: DocuSealFormSubmissionInfo?
    public let template: TemplateReference?
    public let preferences: Preferences?
    public let values: [FieldValue]?
    public let metadata: [String: String]?
    public let auditLogUrl: String?
    public let submissionUrl: String?
    public let documents: [Document]?
    
    public struct Preferences: Codable {
        public let sendEmail: Bool
        public let sendSms: Bool
        
        enum CodingKeys: String, CodingKey {
            case sendEmail = "send_email"
            case sendSms = "send_sms"
        }
    }

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
        status: DocuSealSubmissionStatus,
        openedAt: Date?,
        completedAt: Date?,
        declinedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        submission: DocuSealFormSubmissionInfo?,
        template: TemplateReference?,
        preferences: Preferences?,
        values: [FieldValue]?,
        metadata: [String: String]?,
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
    public let status: DocuSealSubmissionStatus
    public let url: String?
    public let createdAt: Date

    public init(
        id: Int,
        auditLogUrl: String?,
        combinedDocumentUrl: String?,
        status: DocuSealSubmissionStatus,
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
    public let status: DocuSealSubmissionStatus
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
        status: DocuSealSubmissionStatus,
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
    public let eventType: EventType
    public let eventTimestamp: Date

    public enum EventType: String, Codable {
        case sendEmail = "send_email"
        case bounceEmail = "bounce_email"
        case complaintEmail = "complaint_email"
        case sendReminderEmail = "send_reminder_email"
        case sendSms = "send_sms"
        case send2faSms = "send_2fa_sms"
        case openEmail = "open_email"
        case clickEmail = "click_email"
        case clickSms = "click_sms"
        case phoneVerified = "phone_verified"
        case startForm = "start_form"
        case startVerification = "start_verification"
        case completeVerification = "complete_verification"
        case viewForm = "view_form"
        case inviteParty = "invite_party"
        case completeForm = "complete_form"
        case declineForm = "decline_form"
        case apiCompleteForm = "api_complete_form"
    }

    public init(id: Int, submitterId: Int, eventType: EventType, eventTimestamp: Date) {
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
/// Get template creation and update notifications using these events:
/// 'template.created' is triggered when the template is created.
/// 'tempate.updated' is triggered when the template is updated.
public struct DocuSealTemplateWebhookData: Codable {
    /// The template's unique identifier.
    public let id: Int
    /// The template's unique slug.
    public let slug: String
    /// The template's name.
    public let name: String
    /// The template document files.
    public let schema: [TemplateSchema]
    /// The template fields.
    public let fields: [TemplateField]
    /// The submitters.
    public let submitters: [TemplateSubmitter]
    /// Unique identifier of the author of the template.
    public let authorId: Int
    /// Unique identifier of the account of the template.
    public let accountId: Int?
    /// Date and time when the template was archived.
    public let archivedAt: Date?
    /// Date and time when the template was created.
    public let createdAt: Date
    /// Date and time when the template was updated.
    public let updatedAt: Date
    /// Source of the template.
    public let source: Source
    /// Unique identifier of the folder where the template is placed.
    public let folderId: Int?
    /// Identifier of the template in the external system.
    public let externalId: String?
    /// The field preferences.
    public let preferences: TemplatePreferences?
    /// Your application-specific unique string key to identify tempate_id within your app.
    public let applicationKey: String?
    /// Folder name where the template is placed.
    public let folderName: String?
    /// Folder name where the template is placed.
    public let author: UserReference
    /// List of documents attached to the template.
    public let documents: [TemplateDocument]

    /// native, api, embed
    public enum Source: String, Codable {
        case api
        case embed
        case native
    }

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
        source: Source,
        folderId: Int?,
        externalId: String?,
        preferences: TemplatePreferences?,
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

public typealias DocuSealFormWebhookEvent = DocuSealWebhookEvent<DocuSealFormWebhookData>
public typealias DocuSealSubmissionWebhookEvent = DocuSealWebhookEvent<
    DocuSealSubmissionWebhookData
>
public typealias DocuSealTemplateWebhookEvent = DocuSealWebhookEvent<DocuSealTemplateWebhookData>

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
    public static func processFormEvent(data: Data) throws -> DocuSealFormWebhookEvent {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(DocuSealFormWebhookEvent.self, from: data)
    }

    /// Process submission webhook events
    public static func processSubmissionEvent(data: Data) throws -> DocuSealSubmissionWebhookEvent {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(DocuSealSubmissionWebhookEvent.self, from: data)
    }

    /// Process template webhook events
    public static func processTemplateEvent(data: Data) throws -> DocuSealTemplateWebhookEvent {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(DocuSealTemplateWebhookEvent.self, from: data)
    }
}
