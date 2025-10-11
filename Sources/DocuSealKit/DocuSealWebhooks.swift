//
//  DocuSealWebhooks.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation
import NIOCore
import NIOFoundationCompat

public enum DocuSealSubmissionWebhookEventType: String, Codable {
    // Submission Webhooks
    case submissionCreated = "submission.created"
    case submissionArchived = "submission.archived"
    case submissionCompleted = "submission.completed"
    case submissionExpired = "submission.expired"
}

public enum DocuSealFormWebhookEventType: String, Codable {
    // Form Webhooks
    case formViewed = "form.viewed"
    case formStarted = "form.started"
    case formCompleted = "form.completed"
    case formDeclined = "form.declined"
}

public enum DocuSealTemplateWebhookEventType: String, Codable {
    // Template Webhooks
    case templateCreated = "template.created"
    case templateUpdated = "template.updated"
}

// MARK: - Webhook Event Categories

public enum DocuSealWebhookEventCategory {
    case submissionEvent(DocuSealSubmissionWebhookEvent)
    case formEvent(DocuSealFormWebhookEvent)
    case templateEvent(DocuSealTemplateWebhookEvent)
}

// MARK: - Base Webhook Event

public struct DocuSealWebhookEvent<T: Codable, E: Codable>: Codable {
    /// The event type.
    public let eventType: E
    /// The event timestamp.
    /// Example: 2023-09-24T11:20:42Z
    public let timestamp: Date
    /// Submitted data object.
    public let data: T

    public init(eventType: E, timestamp: Date, data: T) {
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
    /// The submitter's unique identifier.
    public let id: Int
    /// The unique submission identifier.
    public let submissionId: Int
    /// The submitter's email address
    /// Example: john.doe@example.com
    public let email: String?
    /// The user agent string that provides information about the submitter's web browser.
    /// Example: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36
    public let ua: String?
    /// The submitter's IP address.
    public let ip: String?
    /// The submitter's name.
    public let name: String?
    /// The submitter's phone number, formatted according to the E.164 standard.
    /// Example: +1234567890
    public let phone: String?
    /// The submitter's role name or title.
    /// Example: First Party
    public let role: String?
    /// Your application-specific unique string key to identify submitter within your app.
    public let externalId: String?
    /// Submitter provided decline message.
    public let declineReason: String?
    /// Sent At
    public let sentAt: Date?
    /// The submitter status.
    /// Possible values: completed, declined, opened, sent, awaiting
    public let status: DocuSealSubmitterStatus
    public let openedAt: Date?
    public let completedAt: Date?
    public let declinedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    /// The submission details.
    public let submission: DocuSealFormSubmissionInfo?
    /// Base template details.
    public let template: TemplateReference?
    /// Preferences
    public let preferences: Preferences?
    /// List of the filled values passed by the submitter.
    public let values: [FieldValue]?
    /// Metadata dictionary with additional submitter information.
    public let metadata: [String: String]?
    /// The audit log PDF URL. Available only if the submission was completed by all submitters.
    public let auditLogUrl: String?
    /// The submission URL.
    public let submissionUrl: String?
    /// Documents
    public let documents: [Document]?

    public struct Preferences: Codable {
        /// The flag indicating whether the submitter has opted to receive an email.
        public let sendEmail: Bool
        /// The flag indicating whether the submitter has opted to receive an SMS.
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
        declineReason: String?,
        sentAt: Date?,
        status: DocuSealSubmitterStatus,
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
    /// The submission's unique identifier.
    public let id: Int
    /// The audit log PDF URL. Available only if the submission was completed by all submitters.
    public let auditLogUrl: String?
    /// The URL of the combined documents with audit log. Combined documents can be enabled via /settings/accounts.
    public let combinedDocumentUrl: String?
    /// The submission status.
    /// Possible values: completed, declined, expired, pending
    public let status: DocuSealSubmissionStatus
    /// The submission URL.
    public let url: String?
    /// The submission creation date.
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
//Get submission creation, completion, expiration, and archiving notifications using these events:
//'submission.created' event is triggered when the submission is created.
//'submission.completed' event is triggered when the submission is completed by all signing parties.
//'submission.expired' event is triggered when the submission expires.
//'submission.archived' event is triggered when the submission is archived.
public struct DocuSealSubmissionWebhookData: Codable {
    /// The submission's unique identifier.
    public let id: Int
    /// The submission archive date.
    public let archivedAt: Date?
    /// The submission creation date.
    public let createdAt: Date?
    /// The submission update date.
    public let updatedAt: Date?
    /// The submission source.
    /// Possible values: invite, bulk, api, embed, link
    public let source: Source?
    /// The submitters order.
    /// Possible values: random, preserved
    public let submittersOrder: SubmittersOrder?
    /// Audit log file URL.
    public let auditLogUrl: String?
    /// The list of submitters for the submission.
    public let submitters: [Submitter]?
    /// Base template details.
    public let template: TemplateReference?
    /// Creator
    public let createdByUser: UserReference?
    /// Submission events
    public let submissionEvents: [DocuSealWebhookSubmissionEvent]?
    /// Documents
    public let documents: [Document]?
    /// The submitter status.
    /// Possible values: completed, declined, opened, sent, awaiting
    public let status: DocuSealSubmissionStatus?
    /// The date and time when the submission was fully completed.
    public let completedAt: Date?

    public enum Source: String, Codable {
        case invite = "invite"
        case bulk = "bulk"
        case api = "api"
        case embed = "embed"
        case link = "link"
    }

    public init(
        id: Int,
        archivedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        source: Source,
        submittersOrder: SubmittersOrder,
        auditLogUrl: String?,
        submitters: [Submitter],
        template: TemplateReference?,
        createdByUser: UserReference?,
        submissionEvents: [DocuSealWebhookSubmissionEvent]?,
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
        self.submissionEvents = submissionEvents
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
        case submissionEvents = "submission_events"
        case documents
        case status
        case completedAt = "completed_at"
    }
}

public struct DocuSealWebhookSubmissionEvent: Codable {
    /// Submission event unique ID number.
    public let id: Int
    /// Unique identifier of the submitter that triggered the event.
    public let submitterId: Int
    /// Event type.
    public let eventType: EventType
    /// Date and time when the event was triggered.
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
    public let preferences: FieldPreferences?
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
        preferences: FieldPreferences?,
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

public typealias DocuSealFormWebhookEvent = DocuSealWebhookEvent<DocuSealFormWebhookData, DocuSealFormWebhookEventType>
public typealias DocuSealSubmissionWebhookEvent = DocuSealWebhookEvent<
    DocuSealSubmissionWebhookData,
    DocuSealSubmissionWebhookEventType
>
public typealias DocuSealTemplateWebhookEvent = DocuSealWebhookEvent<DocuSealTemplateWebhookData, DocuSealTemplateWebhookEventType>

// MARK: - Webhook Handler

public struct DocusealWebhookHandler {
    /// Verify if the webhook request signature is valid (verify that the request came from DocuSeal)
    public static func verifySignature(
        requestBody: ByteBuffer,
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

    /// Parse the webhook event from the request body and return categorized event
    public static func parseWebhookEvent(
        from buffer: ByteBuffer
    ) throws -> DocuSealWebhookEventCategory {
        // First parse just to get the event type
        struct EventTypeContainer: Codable {
            let eventType: String

            enum CodingKeys: String, CodingKey {
                case eventType = "event_type"
            }
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let eventTypeContainer = try decoder.decode(EventTypeContainer.self, from: buffer)

        // Determine category and parse appropriate event type
        switch eventTypeContainer.eventType {
        case "submission.created", "submission.archived", "submission.completed", "submission.expired":
            let event = try decoder.decode(DocuSealSubmissionWebhookEvent.self, from: buffer)
            return .submissionEvent(event)

        case "form.viewed", "form.started", "form.completed", "form.declined":
            let event = try decoder.decode(DocuSealFormWebhookEvent.self, from: buffer)
            return .formEvent(event)

        case "template.created", "template.updated":
            let event = try decoder.decode(DocuSealTemplateWebhookEvent.self, from: buffer)
            return .templateEvent(event)

        default:
            throw DocuSealError.decodingError(
                message: "DocusealWebhookHandler -> Invalid event type: \(eventTypeContainer.eventType)"
            )
        }
    }
}
