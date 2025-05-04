//
//  SubmitterModels.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

// MARK: - Submitter Models

public struct Submitter: Codable {
    public let id: Int
    public let submissionId: Int
    public let uuid: String
    public let email: String
    public let slug: String
    public let sentAt: Date?
    public let openedAt: Date?
    public let completedAt: Date?
    public let declinedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    public let name: String?
    public let phone: String?
    public let externalId: String?
    public let metadata: [String: AnyCodable]?
    public let status: String
    public let values: [FieldValue]?
    public let preferences: [String: AnyCodable]?
    public let role: String
    public let embedSrc: String?
    public let documents: [Document]?
    public let template: TemplateReference?
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
        metadata: [String: AnyCodable]?,
        status: String,
        values: [FieldValue]?,
        preferences: [String: AnyCodable]?,
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

public struct SubmitterListResponse: Codable {
    public let data: [Submitter]
    public let pagination: Pagination

    public init(data: [Submitter], pagination: Pagination) {
        self.data = data
        self.pagination = pagination
    }
}

// MARK: - Submitter List Query

public struct SubmitterListQuery: Codable {
    public let submissionId: Int?
    public let q: String?
    public let slug: String?
    public let completedAfter: String?
    public let completedBefore: String?
    public let externalId: String?
    public let limit: Int?
    public let after: Int?
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

public struct UpdateSubmitterRequest: Codable {
    public let name: String?
    public let email: String?
    public let phone: String?
    public let values: [String: AnyCodable]?
    public let externalId: String?
    public let sendEmail: Bool?
    public let sendSms: Bool?
    public let replyTo: String?
    public let completedRedirectUrl: String?
    public let completed: Bool?
    public let metadata: [String: AnyCodable]?
    public let message: SubmissionMessage?
    public let fields: [SubmissionField]?

    public init(
        name: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        values: [String: AnyCodable]? = nil,
        externalId: String? = nil,
        sendEmail: Bool? = nil,
        sendSms: Bool? = nil,
        replyTo: String? = nil,
        completedRedirectUrl: String? = nil,
        completed: Bool? = nil,
        metadata: [String: AnyCodable]? = nil,
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
