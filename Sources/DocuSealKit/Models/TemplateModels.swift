//
//  TemplateModels.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

// MARK: - Common Models

public struct Document: Codable, Sendable {
    /// Document name.
    public let name: String
    /// Document URL.
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

public struct FieldValue: Codable, Sendable {
    /// The field name.
    public let field: String
    /// The field value.
    public let value: FieldValueType?

    public init(field: String, value: FieldValueType?) {
        self.field = field
        self.value = value
    }

    // MARK: - Convenience Initializers

    /// Initialize with a string value
    public init(field: String, stringValue: String) {
        self.field = field
        self.value = .string(stringValue)
    }

    /// Initialize with a boolean value
    public init(field: String, boolValue: Bool) {
        self.field = field
        self.value = .bool(boolValue)
    }

    /// Initialize with an integer value
    public init(field: String, intValue: Int) {
        self.field = field
        self.value = .int(intValue)
    }

    /// Initialize with a double value
    public init(field: String, doubleValue: Double) {
        self.field = field
        self.value = .double(doubleValue)
    }

    /// Initialize with a nil value
    public init(field: String) {
        self.field = field
        self.value = nil
    }
}

public enum FieldValueType: Codable, Sendable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else {
            throw DecodingError.typeMismatch(
                FieldValueType.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode FieldValueType")
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .string(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        }
    }

    // MARK: - Convenience Properties

    /// Returns the value as a String if it's a string type
    public var stringValue: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }

    /// Returns the value as a Bool if it's a bool type
    public var boolValue: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }

    /// Returns the value as an Int if it's an int type
    public var intValue: Int? {
        if case .int(let value) = self {
            return value
        }
        return nil
    }

    /// Returns the value as a Double if it's a double type
    public var doubleValue: Double? {
        if case .double(let value) = self {
            return value
        }
        return nil
    }

    /// Returns a string representation of the value regardless of type
    public var description: String {
        switch self {
        case .string(let value):
            return value
        case .bool(let value):
            return String(value)
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        }
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
    /// The template's unique identifier.
    public let id: Int
    /// The template's name.
    public let name: String
    /// Your application-specific unique string key to identify template within your app.
    public let externalId: String?
    /// Template folder name.
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
    /// Unique identifier of the author.
    public let id: Int?
    /// First name of the author.
    public let firstName: String?
    /// Last name of the author.
    public let lastName: String?
    /// Author email.
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
    public let preferences: FieldPreferences?
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
        preferences: FieldPreferences?,
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
    /// The attachment UUID.
    public let attachmentUuid: String
    /// The attachment name.
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
    /// The field UUID.
    public let uuid: String
    /// The submitter role UUID.
    public let submitterUuid: String
    /// The field name.
    public let name: String
    ///
    public let type: String
    /// The flag indicating whether the field is required.
    public let required: Bool
    /// The field preferences.
    public let preferences: [String: String]?
    /// List of areas where the field is located in the document.
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
    /// X coordinate of the area where the field is located in the document.
    public let x: Double
    /// Y coordinate of the area where the field is located in the document.
    public let y: Double
    /// Width of the area where the field is located in the document.
    public let w: Double
    /// Height of the area where the field is located in the document.
    public let h: Double
    /// Unique identifier of the attached document where the field is located.
    public let attachmentUuid: String
    /// Page number of the attached document where the field is located.
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
    /// Submitter name.
    public let name: String
    /// Unique identifier of the submitter.
    public let uuid: String

    public init(name: String, uuid: String) {
        self.name = name
        self.uuid = uuid
    }
}

public struct TemplateDocument: Codable, Sendable {
    /// Unique identifier of the document.
    public let id: Int
    /// Unique identifier of the document.
    public let uuid: String
    /// URL of the document.
    public let url: String
    /// Document preview image URL.
    public let previewImageUrl: String?
    /// Document filename.
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
    /// Filter templates based on the name partial match.
    public let q: String?
    /// Filter templates by unique slug.
    /// Example: opaKWh8WWTAcVG
    public let slug: String?
    /// The unique applications-specific identifier provided for the template via API or Embedded template form builder. It allows you to receive only templates with your specified external id.
    public let externalId: String?
    /// Filter templates by folder name.
    public let folder: String?
    /// Get only archived templates instead of active ones.
    public let archived: Bool?
    /// The number of templates to return. Default value is 10. Maximum value is 100.
    public let limit: Int?
    /// The unique identifier of the template to start the list from. It allows you to receive only templates with id greater than the specified value. Pass ID value from the `pagination.next` response to load the next batch of templates.
    public let after: Int?
    /// The unique identifier of the template to end the list with. It allows you to receive only templates with id less than the specified value.
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

// MARK: - Template Query with Include Support
public struct TemplateQuery: Codable, Sendable {
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
