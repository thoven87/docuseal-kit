//
//  TemplateModels.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

// MARK: - Common Models

public struct Document: Codable, Sendable {
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

public struct FieldValue: Codable, Sendable {
    public let field: String
    public let value: String

    public init(field: String, value: String) {
        self.field = field
        self.value = value
    }
}

public struct Pagination: Codable, Sendable {
    public let count: Int
    public let next: Int?
    public let prev: Int?

    public init(count: Int, next: Int?, prev: Int?) {
        self.count = count
        self.next = next
        self.prev = prev
    }
}

public struct TemplateReference: Codable, Sendable {
    public let id: Int
    public let name: String
    public let externalId: String?
    public let folderName: String?
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: Int,
        name: String,
        externalId: String?,
        folderName: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.externalId = externalId
        self.folderName = folderName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case externalId = "external_id"
        case folderName = "folder_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct UserReference: Codable, Sendable {
    public let id: Int?
    public let firstName: String?
    public let lastName: String?
    public let email: String?

    public init(id: Int?, firstName: String?, lastName: String?, email: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

public struct EventRecord: Codable, Sendable {
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

// MARK: - Archive Response

public struct ArchiveResponse: Codable, Sendable {
    public let id: Int
    public let archivedAt: Date

    public init(id: Int, archivedAt: Date) {
        self.id = id
        self.archivedAt = archivedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case archivedAt = "archived_at"
    }
}

// MARK: - Template Models

public struct Template: Codable, Sendable {
    public let id: Int
    public let slug: String
    public let name: String
    public let preferences: TemplatePreferences?
    public let schema: [TemplateSchema]
    public let fields: [TemplateField]
    public let submitters: [TemplateSubmitter]
    public let authorId: Int
    public let archivedAt: Date?
    public let createdAt: Date
    public let updatedAt: Date
    public let source: String
    public let folderId: Int?
    public let folderName: String?
    public let externalId: String?
    public let author: UserReference?
    public let documents: [TemplateDocument]

    public init(
        id: Int,
        slug: String,
        name: String,
        preferences: TemplatePreferences?,
        schema: [TemplateSchema],
        fields: [TemplateField],
        submitters: [TemplateSubmitter],
        authorId: Int,
        archivedAt: Date?,
        createdAt: Date,
        updatedAt: Date,
        source: String,
        folderId: Int?,
        folderName: String?,
        externalId: String?,
        author: UserReference?,
        documents: [TemplateDocument]
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.preferences = preferences
        self.schema = schema
        self.fields = fields
        self.submitters = submitters
        self.authorId = authorId
        self.archivedAt = archivedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.source = source
        self.folderId = folderId
        self.folderName = folderName
        self.externalId = externalId
        self.author = author
        self.documents = documents
    }

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case preferences
        case schema
        case fields
        case submitters
        case authorId = "author_id"
        case archivedAt = "archived_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case source
        case folderId = "folder_id"
        case folderName = "folder_name"
        case externalId = "external_id"
        case author
        case documents
    }
}

public struct TemplateSchema: Codable, Sendable {
    public let attachmentUuid: String
    public let name: String

    public init(attachmentUuid: String, name: String) {
        self.attachmentUuid = attachmentUuid
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case attachmentUuid = "attachment_uuid"
        case name
    }
}

public struct TemplateField: Codable, Sendable {
    public let uuid: String
    public let submitterUuid: String
    public let name: String
    public let type: String
    public let required: Bool
    public let preferences: [String: String]?
    public let areas: [FieldArea]

    public init(
        uuid: String,
        submitterUuid: String,
        name: String,
        type: String,
        required: Bool,
        preferences: [String: String]?,
        areas: [FieldArea]
    ) {
        self.uuid = uuid
        self.submitterUuid = submitterUuid
        self.name = name
        self.type = type
        self.required = required
        self.preferences = preferences
        self.areas = areas
    }

    enum CodingKeys: String, CodingKey {
        case uuid
        case submitterUuid = "submitter_uuid"
        case name
        case type
        case required
        case preferences
        case areas
    }
}

public struct FieldArea: Codable, Sendable {
    public let x: Double
    public let y: Double
    public let w: Double
    public let h: Double
    public let attachmentUuid: String
    public let page: Int

    public init(x: Double, y: Double, w: Double, h: Double, attachmentUuid: String, page: Int) {
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.attachmentUuid = attachmentUuid
        self.page = page
    }

    enum CodingKeys: String, CodingKey {
        case x, y, w, h
        case attachmentUuid = "attachment_uuid"
        case page
    }
}

public struct TemplateSubmitter: Codable, Sendable {
    public let name: String
    public let uuid: String

    public init(name: String, uuid: String) {
        self.name = name
        self.uuid = uuid
    }
}

public struct TemplateDocument: Codable, Sendable {
    public let id: Int
    public let uuid: String
    public let url: String
    public let previewImageUrl: String?
    public let filename: String

    public init(id: Int, uuid: String, url: String, previewImageUrl: String?, filename: String) {
        self.id = id
        self.uuid = uuid
        self.url = url
        self.previewImageUrl = previewImageUrl
        self.filename = filename
    }

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case url
        case previewImageUrl = "preview_image_url"
        case filename
    }
}

// MARK: - Template List Response

public struct TemplateListResponse: Codable, Sendable {
    public let data: [Template]
    public let pagination: Pagination

    public init(data: [Template], pagination: Pagination) {
        self.data = data
        self.pagination = pagination
    }
}

// MARK: - Template List Query

public struct TemplateListQuery: Codable, Sendable {
    public let q: String?
    public let slug: String?
    public let externalId: String?
    public let folder: String?
    public let archived: Bool?
    public let limit: Int?
    public let after: Int?
    public let before: Int?

    public init(
        q: String? = nil,
        slug: String? = nil,
        externalId: String? = nil,
        folder: String? = nil,
        archived: Bool? = nil,
        limit: Int? = nil,
        after: Int? = nil,
        before: Int? = nil
    ) {
        self.q = q
        self.slug = slug
        self.externalId = externalId
        self.folder = folder
        self.archived = archived
        self.limit = limit
        self.after = after
        self.before = before
    }

    enum CodingKeys: String, CodingKey {
        case q
        case slug
        case externalId = "external_id"
        case folder
        case archived
        case limit
        case after
        case before
    }

    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()

        if let q = q { items.append(URLQueryItem(name: "q", value: q)) }
        if let slug = slug { items.append(URLQueryItem(name: "slug", value: slug)) }
        if let externalId = externalId {
            items.append(URLQueryItem(name: "external_id", value: externalId))
        }
        if let folder = folder { items.append(URLQueryItem(name: "folder", value: folder)) }
        if let archived = archived {
            items.append(URLQueryItem(name: "archived", value: String(archived)))
        }
        if let limit = limit { items.append(URLQueryItem(name: "limit", value: String(limit))) }
        if let after = after { items.append(URLQueryItem(name: "after", value: String(after))) }
        if let before = before { items.append(URLQueryItem(name: "before", value: String(before))) }

        return items
    }
}
