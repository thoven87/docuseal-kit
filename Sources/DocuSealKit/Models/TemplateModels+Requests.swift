//
//  TemplateModels+Requests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

// MARK: - Create Template from Word DOCX

public struct CreateTemplateFromDocxRequest: Codable {
    public let name: String?
    public let externalId: String?
    public let folderName: String?
    public let documents: [TemplateDocumentRequest]

    public init(
        name: String? = nil,
        externalId: String? = nil,
        folderName: String? = nil,
        documents: [TemplateDocumentRequest]
    ) {
        self.name = name
        self.externalId = externalId
        self.folderName = folderName
        self.documents = documents
    }

    enum CodingKeys: String, CodingKey {
        case name
        case externalId = "external_id"
        case folderName = "folder_name"
        case documents
    }
}

public struct TemplateDocumentRequest: Codable {
    public let name: String
    public let file: String
    public let fields: [TemplateFieldRequest]?

    public init(
        name: String,
        file: String,
        fields: [TemplateFieldRequest]? = nil
    ) {
        self.name = name
        self.file = file
        self.fields = fields
    }
}

public struct TemplateFieldRequest: Codable {
    public let name: String
    public let type: String?
    public let role: String?
    public let required: Bool?
    public let title: String?
    public let description: String?
    public let areas: [TemplateFieldAreaRequest]?
    public let options: [String]?
    public let preferences: FieldPreferences?

    public init(
        name: String,
        type: String? = nil,
        role: String? = nil,
        required: Bool? = nil,
        title: String? = nil,
        description: String? = nil,
        areas: [TemplateFieldAreaRequest]? = nil,
        options: [String]? = nil,
        preferences: FieldPreferences? = nil
    ) {
        self.name = name
        self.type = type
        self.role = role
        self.required = required
        self.title = title
        self.description = description
        self.areas = areas
        self.options = options
        self.preferences = preferences
    }
}

public struct TemplateFieldAreaRequest: Codable {
    public let x: Double
    public let y: Double
    public let w: Double
    public let h: Double
    public let page: Int
    public let option: String?

    public init(
        x: Double,
        y: Double,
        w: Double,
        h: Double,
        page: Int,
        option: String? = nil
    ) {
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.page = page
        self.option = option
    }
}

// MARK: - Create Template from HTML

public struct CreateTemplateFromHtmlRequest: Codable {
    public let html: String
    public let htmlHeader: String?
    public let htmlFooter: String?
    public let name: String?
    public let size: String?
    public let externalId: String?
    public let folderName: String?
    public let documents: [HtmlDocumentRequest]?

    public init(
        html: String,
        htmlHeader: String? = nil,
        htmlFooter: String? = nil,
        name: String? = nil,
        size: String? = nil,
        externalId: String? = nil,
        folderName: String? = nil,
        documents: [HtmlDocumentRequest]? = nil
    ) {
        self.html = html
        self.htmlHeader = htmlHeader
        self.htmlFooter = htmlFooter
        self.name = name
        self.size = size
        self.externalId = externalId
        self.folderName = folderName
        self.documents = documents
    }

    enum CodingKeys: String, CodingKey {
        case html
        case htmlHeader = "html_header"
        case htmlFooter = "html_footer"
        case name
        case size
        case externalId = "external_id"
        case folderName = "folder_name"
        case documents
    }
}

public struct HtmlDocumentRequest: Codable {
    public let html: String
    public let name: String?

    public init(html: String, name: String? = nil) {
        self.html = html
        self.name = name
    }
}

// MARK: - Create Template from PDF

public struct CreateTemplateFromPdfRequest: Codable {
    public let name: String?
    public let folderName: String?
    public let externalId: String?
    public let documents: [TemplateDocumentRequest]
    public let flatten: Bool?
    public let removeTags: Bool?

    public init(
        name: String? = nil,
        folderName: String? = nil,
        externalId: String? = nil,
        documents: [TemplateDocumentRequest],
        flatten: Bool? = nil,
        removeTags: Bool? = nil
    ) {
        self.name = name
        self.folderName = folderName
        self.externalId = externalId
        self.documents = documents
        self.flatten = flatten
        self.removeTags = removeTags
    }

    enum CodingKeys: String, CodingKey {
        case name
        case folderName = "folder_name"
        case externalId = "external_id"
        case documents
        case flatten
        case removeTags = "remove_tags"
    }
}

// MARK: - Merge Templates

public struct MergeTemplatesRequest: Codable {
    public let templateIds: [Int]
    public let name: String?
    public let folderName: String?
    public let externalId: String?
    public let roles: [String]?

    public init(
        templateIds: [Int],
        name: String? = nil,
        folderName: String? = nil,
        externalId: String? = nil,
        roles: [String]? = nil
    ) {
        self.templateIds = templateIds
        self.name = name
        self.folderName = folderName
        self.externalId = externalId
        self.roles = roles
    }

    enum CodingKeys: String, CodingKey {
        case templateIds = "template_ids"
        case name
        case folderName = "folder_name"
        case externalId = "external_id"
        case roles
    }
}

// MARK: - Update Template

public struct UpdateTemplateRequest: Codable {
    public let name: String?
    public let folderName: String?
    public let roles: [String]?
    public let archived: Bool?

    public init(
        name: String? = nil,
        folderName: String? = nil,
        roles: [String]? = nil,
        archived: Bool? = nil
    ) {
        self.name = name
        self.folderName = folderName
        self.roles = roles
        self.archived = archived
    }

    enum CodingKeys: String, CodingKey {
        case name
        case folderName = "folder_name"
        case roles
        case archived
    }
}

// MARK: - Update Template Documents

public struct UpdateTemplateDocumentsRequest: Codable {
    public let documents: [UpdateTemplateDocumentRequest]
    public let merge: Bool?

    public init(
        documents: [UpdateTemplateDocumentRequest],
        merge: Bool? = nil
    ) {
        self.documents = documents
        self.merge = merge
    }
}

public struct UpdateTemplateDocumentRequest: Codable {
    public let name: String?
    public let file: String?
    public let html: String?
    public let position: Int?
    public let replace: Bool?
    public let remove: Bool?

    public init(
        name: String? = nil,
        file: String? = nil,
        html: String? = nil,
        position: Int? = nil,
        replace: Bool? = nil,
        remove: Bool? = nil
    ) {
        self.name = name
        self.file = file
        self.html = html
        self.position = position
        self.replace = replace
        self.remove = remove
    }
}
