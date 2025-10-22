//
//  SubmitterModels.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

//in DocuSeal, submitter preferences are configuration options that control how submitters interact with documents. These preferences can be set when creating or updating submissions.
//
//For submitters, the preferences can include:
//
//send_email: Boolean that determines whether to send an email invitation to the submitter
//send_sms: Boolean that determines whether to send an SMS invitation to the submitter
//email_message_uuid: String identifier for a specific email message template
//When working with embedded forms, you can set preferences for submitters. For example:

public struct SubmitterPreferences: Codable, Sendable {
    /// Should send email
    public let sendEmail: Bool
    /// Should send SMS
    public let sendSMS: Bool
    /// The message UUID
    public let emailMessageUuid: String?

    enum CodingKeys: String, CodingKey {
        case sendEmail = "send_email"
        case sendSMS = "send_sms"
        case emailMessageUuid = "email_message_uuid"
    }
}

// MARK: - Submitter Models

// The status of the submitter status.
public enum DocuSealSubmitterStatus: String, Codable, Sendable {
    /// Initial status when a submitter is created but hasn't been sent the document yet
    case awaiting
    /// The submitter has completed their part of the signing process
    case completed
    /// The submitter has declined to sign the document
    case declined
    /// The submitter has opened the signing form
    case opened
    /// The signing request has been sent to the submitter
    case sent
}

public struct Submitter: Codable, Sendable {
    /// The submitter's unique identifier.
    public let id: Int
    /// The unique submission identifier.
    public let submissionId: Int
    /// The submitter UUID.
    public let uuid: String
    /// The email address of the submitter.
    /// Example: john.doe@example.com
    public let email: String
    /// The unique slug of the document template.
    public let slug: String
    /// The date and time when the signing request was sent to the submitter.
    public let sentAt: Date?
    /// The date and time when the submitter opened the signing form.
    public let openedAt: Date?
    /// The date and time when the submitter completed the signing form.
    public let completedAt: Date?
    /// The date and time when the submitter declined the signing form.
    public let declinedAt: Date?
    /// The date and time when the submitter was created.
    public let createdAt: Date
    /// The date and time when the submitter was last updated.
    public let updatedAt: Date
    /// The name of the submitter.
    public let name: String?
    /// The phone number of the submitter, formatted according to the E.164 standard.
    /// Example: +1234567890
    public let phone: String?
    /// Your application-specific unique string key to identify this submitter within your app.
    public let externalId: String?
    /// Metadata object with additional submitter information.
    /// Example: [ "customField": "value'" ]
    public let metadata: [String: String]?
    /// The submitter status.
    /// Possible values: completed, declined, opened, sent, awaiting
    public let status: DocuSealSubmitterStatus
    /// An object with pre-filled values for the submission. Use field names for keys of the object. For more configurations see `fields` param.
    public let values: [FieldValue]?
    /// The submitter preferences.
    public let preferences: SubmitterPreferences?
    /// The role name or title of the submitter.
    /// Example: First Party
    public let role: String
    /// Embed source
    public let embedSrc: String?
    /// The list of documents for the submission.
    public let documents: [Document]?
    /// Base template details.
    public let template: TemplateReference?
    ///
    public let eventRecords: [EventRecord]?

    public init(
        id: Int,
        submissionId: Int,
        uuid: String,
        email: String,
        slug: String,
        sentAt: Date?,
        openedAt: Date?,
        completedAt: Date?,
        declinedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        name: String?,
        phone: String?,
        externalId: String?,
        metadata: [String: String]?,
        status: DocuSealSubmitterStatus,
        values: [FieldValue]?,
        preferences: SubmitterPreferences,
        role: String,
        embedSrc: String?,
        documents: [Document]?,
        template: TemplateReference?,
        eventRecords: [EventRecord]?
    ) {
        self.id = id
        self.submissionId = submissionId
        self.uuid = uuid
        self.email = email
        self.slug = slug
        self.sentAt = sentAt
        self.openedAt = openedAt
        self.completedAt = completedAt
        self.declinedAt = declinedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.phone = phone
        self.externalId = externalId
        self.metadata = metadata
        self.status = status
        self.values = values
        self.preferences = preferences
        self.role = role
        self.embedSrc = embedSrc
        self.documents = documents
        self.template = template
        self.eventRecords = eventRecords
    }

    enum CodingKeys: String, CodingKey {
        case id
        case submissionId = "submission_id"
        case uuid
        case email
        case slug
        case sentAt = "sent_at"
        case openedAt = "opened_at"
        case completedAt = "completed_at"
        case declinedAt = "declined_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
        case phone
        case externalId = "external_id"
        case metadata
        case status
        case values
        case preferences
        case role
        case embedSrc = "embed_src"
        case documents
        case template
        case eventRecords = "submission_events"
    }
}

// MARK: - Submitter List Response

public struct SubmitterListResponse: Codable, Sendable {
    public let data: [Submitter]
    public let pagination: Pagination

    public init(data: [Submitter], pagination: Pagination) {
        self.data = data
        self.pagination = pagination
    }
}

// MARK: - Submitter Query with Include Support
public struct SubmitterQuery: Codable, Sendable {
    /// Include additional related data
    public let include: String?

    public init(include: String? = nil) {
        self.include = include
    }

    public var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []

        if let include = include {
            items.append(URLQueryItem(name: "include", value: include))
        }

        return items
    }
}

// MARK: - Submitter List Query

public struct SubmitterListQuery: Codable, Sendable {
    /// The submission ID allows you to receive only the submitters related to that specific submission.
    public let submissionId: Int?
    /// Filter submitters on name, email or phone partial match.
    public let q: String?
    /// Filter submissions by unique slug.
    /// Example: NtLDQM7eJX2ZMd
    public let slug: String?
    /// The date and time string value to filter submitters that completed the submission after the specified date and time.
    /// Example: 2024-03-05 9:32:20
    public let completedAfter: String?
    /// The date and time string value to filter submitters that completed the submission before the specified date and time.
    /// Example: 2024-03-06 19:32:20
    public let completedBefore: String?
    /// The template ID allows you to receive only the submissions created from that specific template.
    public let externalId: String?
    /// The number of submissions to return. Default value is 10. Maximum value is 100.
    public let limit: Int?
    /// The unique identifier of the submitter to start the list from. It allows you to receive only submitters with id greater than the specified value. Pass ID value from the `pagination.next` response to load the next batch of submitters.
    public let after: Int?
    /// The unique identifier of the submitter to end the list with. It allows you to receive only submitters with id less than the specified value.
    public let before: Int?

    public init(
        submissionId: Int? = nil,
        q: String? = nil,
        slug: String? = nil,
        completedAfter: String? = nil,
        completedBefore: String? = nil,
        externalId: String? = nil,
        limit: Int? = nil,
        after: Int? = nil,
        before: Int? = nil
    ) {
        self.submissionId = submissionId
        self.q = q
        self.slug = slug
        self.completedAfter = completedAfter
        self.completedBefore = completedBefore
        self.externalId = externalId
        self.limit = limit
        self.after = after
        self.before = before
    }

    enum CodingKeys: String, CodingKey {
        case submissionId = "submission_id"
        case q
        case slug
        case completedAfter = "completed_after"
        case completedBefore = "completed_before"
        case externalId = "external_id"
        case limit
        case after
        case before
    }

    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()

        if let submissionId = submissionId {
            items.append(URLQueryItem(name: "submission_id", value: String(submissionId)))
        }

        if let q = q { items.append(URLQueryItem(name: "q", value: q)) }
        if let slug = slug { items.append(URLQueryItem(name: "slug", value: slug)) }
        if let completedAfter = completedAfter {
            items.append(URLQueryItem(name: "completed_after", value: completedAfter))
        }
        if let completedBefore = completedBefore {
            items.append(URLQueryItem(name: "completed_before", value: completedBefore))
        }
        if let externalId = externalId {
            items.append(URLQueryItem(name: "external_id", value: externalId))
        }
        if let limit = limit { items.append(URLQueryItem(name: "limit", value: String(limit))) }
        if let after = after { items.append(URLQueryItem(name: "after", value: String(after))) }
        if let before = before { items.append(URLQueryItem(name: "before", value: String(before))) }

        return items
    }
}

// MARK: - Update Submitter Request

public struct UpdateSubmitterRequest: Codable, Sendable {
    /// The name of the submitter.
    public let name: String?
    /// The email address of the submitter.
    /// Example: john.doe@example.com
    public let email: String?
    /// The phone number of the submitter, formatted according to the E.164 standard.
    /// Example: +1234567890
    public let phone: String?
    /// FieldValue with pre-filled values for the submission. Use field names for keys of the object. For more configurations see `fields` param.
    public let values: [FieldValue]?
    /// Your application-specific unique string key to identify this submitter within your app.
    public let externalId: String?
    /// Set `true` to re-send signature request emails.
    public let sendEmail: Bool?
    /// Set `true` to re-send signature request via phone number SMS.
    /// Default: false
    public let sendSms: Bool
    /// Specify Reply-To address to use in the notification emails.
    public let replyTo: String?
    /// Submitter specific URL to redirect to after the submission completion.
    public let completedRedirectUrl: String?
    /// Pass `true` to mark submitter as completed and auto-signed via API.
    public let completed: Bool?
    /// Metadata dictionary with additional submitter information.
    /// Example:  [ "customField": "value" ]
    public let metadata: [String: String]?
    /// Submitter Message
    public let message: SubmissionMessage?
    /// A list of configurations for template document form fields.
    public let fields: [SubmissionField]?

    public init(
        name: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        values: [FieldValue]? = nil,
        externalId: String? = nil,
        sendEmail: Bool? = nil,
        sendSms: Bool = false,
        replyTo: String? = nil,
        completedRedirectUrl: String? = nil,
        completed: Bool? = nil,
        metadata: [String: String]? = nil,
        message: SubmissionMessage? = nil,
        fields: [SubmissionField]? = nil
    ) {
        self.name = name
        self.email = email
        self.phone = phone
        self.values = values
        self.externalId = externalId
        self.sendEmail = sendEmail
        self.sendSms = sendSms
        self.replyTo = replyTo
        self.completedRedirectUrl = completedRedirectUrl
        self.completed = completed
        self.metadata = metadata
        self.message = message
        self.fields = fields
    }

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case values
        case externalId = "external_id"
        case sendEmail = "send_email"
        case sendSms = "send_sms"
        case replyTo = "reply_to"
        case completedRedirectUrl = "completed_redirect_url"
        case completed
        case metadata
        case message
        case fields
    }
}
