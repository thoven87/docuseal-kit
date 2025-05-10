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

public struct SubmissionListQuery: Codable {
    public let templateId: Int?
    public let status: String?
    public let q: String?
    public let slug: String?
    public let templateFolder: String?
    public let archived: Bool?
    public let limit: Int?
    public let after: Int?
    public let before: Int?

    public init(
        templateId: Int? = nil,
        status: String? = nil,
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
        if let status = status { items.append(URLQueryItem(name: "status", value: status)) }
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

public struct CreateSubmissionRequest: Codable {
    public let templateId: Int
    public let sendEmail: Bool?
    public let sendSms: Bool?
    public let order: String?
    public let completedRedirectUrl: String?
    public let bccCompleted: String?
    public let replyTo: String?
    public let expireAt: String?
    public let message: SubmissionMessage?
    public let submitters: [SubmissionSubmitter]

    public init(
        templateId: Int,
        sendEmail: Bool? = true,
        sendSms: Bool? = nil,
        order: String? = nil,
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
    public let subject: String?
    public let body: String?

    public init(subject: String? = nil, body: String? = nil) {
        self.subject = subject
        self.body = body
    }
}

public struct SubmissionSubmitter: Codable {
    public let name: String?
    public let role: String?
    public let email: String
    public let phone: String?
    public let values: [FieldValue]?
    public let externalId: String?
    public let completed: Bool?
    public let metadata: [String: String]?
    public let sendEmail: Bool?
    public let sendSms: Bool?
    public let replyTo: String?
    public let completedRedirectUrl: String?
    public let message: SubmissionMessage?
    public let fields: [SubmissionField]?
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
        sendEmail: Bool? = nil,
        sendSms: Bool? = nil,
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
    public let name: String
    public let defaultValue: [String: String]
    public let readonly: Bool?
    public let required: Bool?
    public let title: String?
    public let description: String?
    public let validationPattern: String?
    public let invalidMessage: String?
    public let preferences: FieldPreferences?

    public init(
        name: String,
        defaultValue: [String: String],
        readonly: Bool? = nil,
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

public struct FieldPreferences: Codable, Sendable {
    public let fontSize: Int?
    public let fontType: String?
    public let font: String?
    public let color: String?
    public let align: String?
    public let valign: String?
    public let format: String?
    public let price: Double?
    public let currency: String?
    public let mask: Bool?

    public init(
        fontSize: Int? = nil,
        fontType: String? = nil,
        font: String? = nil,
        color: String? = nil,
        align: String? = nil,
        valign: String? = nil,
        format: String? = nil,
        price: Double? = nil,
        currency: String? = nil,
        mask: Bool? = nil
    ) {
        self.fontSize = fontSize
        self.fontType = fontType
        self.font = font
        self.color = color
        self.align = align
        self.valign = valign
        self.format = format
        self.price = price
        self.currency = currency
        self.mask = mask
    }

    enum CodingKeys: String, CodingKey {
        case fontSize = "font_size"
        case fontType = "font_type"
        case font
        case color
        case align
        case valign
        case format
        case price
        case currency
        case mask
    }
}

// MARK: - Create Submissions From Emails Request

public struct CreateSubmissionsFromEmailsRequest: Codable {
    public let templateId: Int
    public let emails: String
    public let sendEmail: Bool?
    public let message: SubmissionMessage?

    public init(
        templateId: Int,
        emails: String,
        sendEmail: Bool? = nil,
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
