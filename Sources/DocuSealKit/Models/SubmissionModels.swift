//
//  SubmissionModels.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

// MARK: - Submission Models

public struct Submission: Codable {
    public let id: Int
    public let source: String
    public let submittersOrder: String
    public let slug: String
    public let auditLogUrl: String?
    public let combinedDocumentUrl: String?
    public let expireAt: Date?
    public let completedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    public let archivedAt: Date?
    public let submitters: [Submitter]
    public let template: TemplateReference
    public let createdByUser: UserReference?
    public let eventRecords: [EventRecord]?
    public let documents: [Document]?
    public let status: String

    public init(
        id: Int,
        source: String,
        submittersOrder: String,
        slug: String,
        auditLogUrl: String?,
        combinedDocumentUrl: String?,
        expireAt: Date?,
        completedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        archivedAt: Date?,
        submitters: [Submitter],
        template: TemplateReference,
        createdByUser: UserReference?,
        eventRecords: [EventRecord]?,
        documents: [Document]?,
        status: String
    ) {
        self.id = id
        self.source = source
        self.submittersOrder = submittersOrder
        self.slug = slug
        self.auditLogUrl = auditLogUrl
        self.combinedDocumentUrl = combinedDocumentUrl
        self.expireAt = expireAt
        self.completedAt = completedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.archivedAt = archivedAt
        self.submitters = submitters
        self.template = template
        self.createdByUser = createdByUser
        self.eventRecords = eventRecords
        self.documents = documents
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case id
        case source
        case submittersOrder = "submitters_order"
        case slug
        case auditLogUrl = "audit_log_url"
        case combinedDocumentUrl = "combined_document_url"
        case expireAt = "expire_at"
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case archivedAt = "archived_at"
        case submitters
        case template
        case createdByUser = "created_by_user"
        case eventRecords = "submission_events"
        case documents
        case status
    }
}

public struct SubmissionDocuments: Codable {
    public let id: Int
    public let documents: [Document]

    public init(id: Int, documents: [Document]) {
        self.id = id
        self.documents = documents
    }
}

// MARK: - Submission List Response

public struct SubmissionListResponse: Codable {
    public let data: [Submission]
    public let pagination: Pagination

    public init(data: [Submission], pagination: Pagination) {
        self.data = data
        self.pagination = pagination
    }
}

// MARK: - Submission List Query

public enum SubmissionStatus: String, Codable {
    case pending
    case completed
    case declined
    case expired
}
public struct SubmissionListQuery: Codable {
    /// The template ID allows you to receive only the submissions created from that specific template.
    public let templateId: Int?
    /// Filter submissions by status.
    /// Possible values: pending, completed, declined, expired
    public let status: SubmissionStatus?
    /// Filter submissions based on submitters name, email or phone partial match.
    public let q: String?
    /// Filter submissions by unique slug.
    /// Example: NtLDQM7eJX2ZMd
    public let slug: String?
    /// Filter submissions by template folder name.
    public let templateFolder: String?
    /// Returns only archived submissions when `true` and only active submissions when `false`.
    public let archived: Bool?
    /// The number of submissions to return. Default value is 10. Maximum value is 100.
    public let limit: Int?
    /// The unique identifier of the submission to start the list from. It allows you to receive only submissions with an ID greater than the specified value. Pass ID value from the `pagination.next` response to load the next batch of submissions.
    public let after: Int?
    /// The unique identifier of the submission that marks the end of the list. It allows you to receive only submissions with an ID less than the specified value.
    public let before: Int?

    public init(
        templateId: Int? = nil,
        status: SubmissionStatus? = nil,
        q: String? = nil,
        slug: String? = nil,
        templateFolder: String? = nil,
        archived: Bool? = nil,
        limit: Int? = nil,
        after: Int? = nil,
        before: Int? = nil
    ) {
        self.templateId = templateId
        self.status = status
        self.q = q
        self.slug = slug
        self.templateFolder = templateFolder
        self.archived = archived
        self.limit = limit
        self.after = after
        self.before = before
    }

    enum CodingKeys: String, CodingKey {
        case templateId = "template_id"
        case status
        case q
        case slug
        case templateFolder = "template_folder"
        case archived
        case limit
        case after
        case before
    }

    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()

        if let templateId = templateId {
            items.append(URLQueryItem(name: "template_id", value: String(templateId)))
        }
        if let status = status { items.append(URLQueryItem(name: "status", value: status.rawValue)) }
        if let q = q { items.append(URLQueryItem(name: "q", value: q)) }
        if let slug = slug { items.append(URLQueryItem(name: "slug", value: slug)) }
        if let templateFolder = templateFolder {
            items.append(URLQueryItem(name: "template_folder", value: templateFolder))
        }
        if let archived = archived {
            items.append(URLQueryItem(name: "archived", value: String(archived)))
        }
        if let limit = limit { items.append(URLQueryItem(name: "limit", value: String(limit))) }
        if let after = after { items.append(URLQueryItem(name: "after", value: String(after))) }
        if let before = before { items.append(URLQueryItem(name: "before", value: String(before))) }

        return items
    }
}

// MARK: - Create Submission Request

public enum SubmittersOrder: String, Codable {
    case random = "random"
    case preserved = "preserved"
}

public struct CreateSubmissionRequest: Codable {
    /// The unique identifier of the template. Document template forms can be created via the Web UI, PDF and DOCX API, or HTML API.
    /// Example: 1000001
    public let templateId: Int
    /// Set `false` to disable signature request emails sending.
    // Default: true
    public let sendEmail: Bool
    /// Set `true` to send signature request via phone number and SMS.
    /// Default: false
    public let sendSms: Bool
    /// Pass 'random' to send signature request emails to all parties right away. The order is 'preserved' by default so the second party will receive a signature request email only after the document is signed by the first party.
    /// Default: preserved
    /// Possible values: preserved, random
    public let order: SubmittersOrder
    /// Specify URL to redirect to after the submission completion.
    public let completedRedirectUrl: String?
    /// Specify BCC address to send signed documents to after the completion.
    public let bccCompleted: String?
    /// Specify Reply-To address to use in the notification emails.
    public let replyTo: String?
    /// Specify the expiration date and time after which the submission becomes unavailable for signature.
    /// Example: 2024-09-01 12:00:00 UTC
    public let expireAt: String?
    /// Submitting message
    public let message: SubmissionMessage?
    /// The list of submitters for the submission.
    public let submitters: [SubmissionSubmitter]

    public init(
        templateId: Int,
        sendEmail: Bool = true,
        sendSms: Bool = false,
        order: SubmittersOrder = .preserved,
        completedRedirectUrl: String? = nil,
        bccCompleted: String? = nil,
        replyTo: String? = nil,
        expireAt: String? = nil,
        message: SubmissionMessage? = nil,
        submitters: [SubmissionSubmitter]
    ) {
        self.templateId = templateId
        self.sendEmail = sendEmail
        self.sendSms = sendSms
        self.order = order
        self.completedRedirectUrl = completedRedirectUrl
        self.bccCompleted = bccCompleted
        self.replyTo = replyTo
        self.expireAt = expireAt
        self.message = message
        self.submitters = submitters
    }

    enum CodingKeys: String, CodingKey {
        case templateId = "template_id"
        case sendEmail = "send_email"
        case sendSms = "send_sms"
        case order
        case completedRedirectUrl = "completed_redirect_url"
        case bccCompleted = "bcc_completed"
        case replyTo = "reply_to"
        case expireAt = "expire_at"
        case message
        case submitters
    }
}

public struct SubmissionMessage: Codable {
    /// Custom signature request email subject.
    public let subject: String?
    /// Custom signature request email body. Can include the following variables: {{template.name}}, {{submitter.link}}, {{account.name}}.
    public let body: String?

    public init(subject: String? = nil, body: String? = nil) {
        self.subject = subject
        self.body = body
    }
}

public struct SubmissionSubmitter: Codable {
    /// The name of the submitter.
    public let name: String?
    /// The role name or title of the submitter.
    /// Example: First Party
    public let role: String?
    /// The email address of the submitter.
    /// Example: john.doe@example.com
    public let email: String
    /// The phone number of the submitter, formatted according to the E.164 standard.
    /// Example: +1234567890
    public let phone: String?
    /// An object with pre-filled values for the submission. Use field names for keys of the object. For more configurations see `fields` param.
    public let values: [FieldValue]?
    /// Your application-specific unique string key to identify this submitter within your app.
    public let externalId: String?
    /// Pass `true` to mark submitter as completed and auto-signed via API.
    public let completed: Bool?
    /// Metadata dictionary with additional submitter information.
    /// Example: [ "customField": "value"  ]
    public let metadata: [String: String]?
    /// Set `false` to disable signature request emails sending only for this submitter.
    /// Default: true
    public let sendEmail: Bool
    /// Set `true` to send signature request via phone number and SMS.
    /// Default: false
    public let sendSms: Bool
    /// Specify Reply-To address to use in the notification emails for this submitter.
    public let replyTo: String?
    /// Submitter specific URL to redirect to after the submission completion.
    public let completedRedirectUrl: String?
    /// Message to submitter
    public let message: SubmissionMessage?
    /// A list of configurations for template document form fields.
    public let fields: [SubmissionField]?
    /// A list of roles for the submitter. Use this param to merge multiple roles into one submitter.
    public let roles: [String]?

    public init(
        name: String? = nil,
        role: String? = nil,
        email: String,
        phone: String? = nil,
        values: [FieldValue]? = nil,
        externalId: String? = nil,
        completed: Bool? = nil,
        metadata: [String: String]? = nil,
        sendEmail: Bool = true,
        sendSms: Bool = false,
        replyTo: String? = nil,
        completedRedirectUrl: String? = nil,
        message: SubmissionMessage? = nil,
        fields: [SubmissionField]? = nil,
        roles: [String]? = nil
    ) {
        self.name = name
        self.role = role
        self.email = email
        self.phone = phone
        self.values = values
        self.externalId = externalId
        self.completed = completed
        self.metadata = metadata
        self.sendEmail = sendEmail
        self.sendSms = sendSms
        self.replyTo = replyTo
        self.completedRedirectUrl = completedRedirectUrl
        self.message = message
        self.fields = fields
        self.roles = roles
    }

    enum CodingKeys: String, CodingKey {
        case name
        case role
        case email
        case phone
        case values
        case externalId = "external_id"
        case completed
        case metadata
        case sendEmail = "send_email"
        case sendSms = "send_sms"
        case replyTo = "reply_to"
        case completedRedirectUrl = "completed_redirect_url"
        case message
        case fields
        case roles
    }
}

public struct SubmissionField: Codable, Sendable {
    /// Document template field name.
    /// Example: First Name
    public let name: String
    /// Default value of the field. Use base64 encoded file or a public URL to the image file to set default signature or image fields.
    // Example: Acme
    public let defaultValue: [String: String]
    /// Set `true` to make it impossible for the submitter to edit predefined field value.
    /// Default: false
    public let readonly: Bool
    /// Set `true` to make the field required.
    public let required: Bool?
    /// Field title displayed to the user instead of the name, shown on the signing form. Supports Markdown.
    public let title: String?
    /// Field description displayed on the signing form. Supports Markdown.
    public let description: String?
    /// HTML field validation pattern string based on https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/pattern specification.
    /// Example: [A-Z]{4}
    public let validationPattern: String?
    /// A custom message to display on pattern validation failure.
    public let invalidMessage: String?
    /// Field preferences
    public let preferences: FieldPreferences?

    public init(
        name: String,
        defaultValue: [String: String],
        readonly: Bool = false,
        required: Bool? = nil,
        title: String? = nil,
        description: String? = nil,
        validationPattern: String? = nil,
        invalidMessage: String? = nil,
        preferences: FieldPreferences? = nil
    ) {
        self.name = name
        self.defaultValue = defaultValue
        self.readonly = readonly
        self.required = required
        self.title = title
        self.description = description
        self.validationPattern = validationPattern
        self.invalidMessage = invalidMessage
        self.preferences = preferences
    }

    enum CodingKeys: String, CodingKey {
        case name
        case defaultValue = "default_value"
        case readonly
        case required
        case title
        case description
        case validationPattern = "validation_pattern"
        case invalidMessage = "invalid_message"
        case preferences
    }
}

// MARK: - Create Submissions From Emails Request

public struct CreateSubmissionsFromEmailsRequest: Codable {
    /// The unique identifier of the template.
    /// Example: 1000001
    public let templateId: Int
    /// A comma-separated list of email addresses to send the submission to.
    /// Example: hi@docuseal.com, example@docuseal.com
    public let emails: String
    /// Set `false` to disable signature request emails sending.
    /// Default: true
    public let sendEmail: Bool
    /// Message to include
    public let message: SubmissionMessage?

    public init(
        templateId: Int,
        emails: String,
        sendEmail: Bool = true,
        message: SubmissionMessage? = nil
    ) {
        self.templateId = templateId
        self.emails = emails
        self.sendEmail = sendEmail
        self.message = message
    }

    enum CodingKeys: String, CodingKey {
        case templateId = "template_id"
        case emails
        case sendEmail = "send_email"
        case message
    }
}
