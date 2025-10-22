//
//  TemplateModels+Requests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

// MARK: - Create Template from Word DOCX

public struct CreateTemplateFromDocxRequest: Codable, Sendable {
    /// Name of the template
    /// Example: Test DOCX
    public let name: String?
    /// Your application-specific unique string key to identify this template within your app. Existing template with specified `external_id` will be updated with a new document.
    /// Example: unique-key
    public let externalId: String?
    /// The folder's name to which the template should be created.
    public let folderName: String?
    /// Set to `true` to make the template available via a shared link. This will allow anyone with the link to create a submission from this template.
    public let sharedLink: Bool?
    /// Documents to include with this payload
    public let documents: [TemplateDocumentRequest]

    public init(
        name: String? = nil,
        externalId: String? = nil,
        folderName: String? = nil,
        sharedLink: Bool? = nil,
        documents: [TemplateDocumentRequest]
    ) {
        self.name = name
        self.externalId = externalId
        self.folderName = folderName
        self.sharedLink = sharedLink
        self.documents = documents
    }

    enum CodingKeys: String, CodingKey {
        case name
        case externalId = "external_id"
        case folderName = "folder_name"
        case sharedLink = "shared_link"
        case documents
    }
}

public struct TemplateDocumentRequest: Codable, Sendable {
    /// Name of the document.
    public let name: String
    /// Base64-encoded content of the DOCX file or downloadable file URL
    /// Example: base64
    public let file: String
    /// Fields are optional if you use {{...}} text tags to define fields in the document.
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

public enum TemplateFieldType: String, Codable, Sendable {
    case heading = "heading"
    case text = "text"
    case signature = "signature"
    case initials = "initials"
    case date = "date"
    case number = "number"
    case image = "image"
    case checkbox = "checkbox"
    case multiple = "multiple"
    case file = "file"
    case radio = "radio"
    case select = "select"
    case cells = "cells"
    case stamp = "stamp"
    case payment = "payment"
    case phone = "phone"
    case verification = "verification"
}

public struct TemplateFieldRequest: Codable, Sendable {
    /// Name of the field.
    public let name: String
    /// Type of the field (e.g., text, signature, date, initials).
    ///    Possible values: heading, text, signature, initials, date, number, image, checkbox, multiple, file, radio, select, cells, stamp, payment, phone, verification
    public let type: TemplateFieldType?
    /// Role name of the signer.
    public let role: String?
    /// Indicates if the field is required.
    public let required: Bool?
    /// Field title displayed to the user instead of the name, shown on the signing form. Supports Markdown.
    public let title: String?
    /// Field description displayed on the signing form. Supports Markdown.
    public let description: String?
    /// Areas
    public let areas: [TemplateFieldAreaRequest]?
    /// An array of option values for 'select' field type.
    /// Example: ["Option A","Option B"]
    public let options: [String]?
    /// FieldPreferences
    public let preferences: FieldPreferences?

    public init(
        name: String,
        type: TemplateFieldType? = nil,
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

public struct TemplateFieldAreaRequest: Codable, Sendable {
    /// X-coordinate of the field area.
    public let x: Double
    /// Y-coordinate of the field area.
    public let y: Double
    /// Width of the field area.
    public let w: Double
    /// Height of the field area.
    public let h: Double
    /// Page number of the field area. Starts from 1.
    public let page: Int
    /// Option string value for 'radio' and 'multiple' select field types.
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

public enum DocuSealPageSize: String, Codable, Sendable {
    case letter = "Letter"
    case a0 = "A0"
    case a1 = "A1"
    case a2 = "A2"
    case a3 = "A3"
    case a4 = "A4"
    case a5 = "A5"
    case a6 = "A6"
    case a10 = "A10"
    case legal = "Legal"
    case tabloid = "Tabloid"
    case ledge = "Ledger"
}

public struct CreateTemplateFromHtmlRequest: Codable, Sendable {
    /// HTML template with field tags.
    ///    Example: <p>Lorem Ipsum is simply dummy text of the <text-field name="Industry" role="First Party" required="false" style="width: 80px; height: 16px; display: inline-block; margin-bottom: -4px"> </text-field> and typesetting industry</p>
    public let html: String
    /// HTML template of the header to be displayed on every page.
    public let htmlHeader: String?
    /// HTML template of the footer to be displayed on every page.
    public let htmlFooter: String?
    /// Template name. Random uuid will be assigned when not specified.
    /// Example: Test Template
    public let name: String?
    /// Page size. Letter 8.5 x 11 will be assigned when not specified.
    ///    Default: Letter
    ///    Possible values: Letter, Legal, Tabloid, Ledger, A0, A1, A2, A3, A4, A5, A6
    ///    Example: A4
    public let size: DocuSealPageSize
    /// Your application-specific unique string key to identify this template within your app. Existing template with specified `external_id` will be updated with a new HTML.
    /// Example: 714d974e-83d8-11ee-b962-0242ac120002
    public let externalId: String?
    /// The folder's name to which the template should be created.
    public let folderName: String?
    /// Set to `true` to make the template available via a shared link. This will allow anyone with the link to create a submission from this template.
    public let sharedLink: Bool?
    /// The list of documents built from HTML. Can be used to create a template with multiple documents. Leave `documents` param empty when using a top-level `html` param for a template with a single document.
    public let documents: [HtmlDocumentRequest]?

    public init(
        html: String,
        htmlHeader: String? = nil,
        htmlFooter: String? = nil,
        name: String? = nil,
        size: DocuSealPageSize = .letter,
        externalId: String? = nil,
        folderName: String? = nil,
        sharedLink: Bool? = nil,
        documents: [HtmlDocumentRequest]? = nil
    ) {
        self.html = html
        self.htmlHeader = htmlHeader
        self.htmlFooter = htmlFooter
        self.name = name
        self.size = size
        self.externalId = externalId
        self.folderName = folderName
        self.sharedLink = sharedLink
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
        case sharedLink = "shared_link"
        case documents
    }
}

public struct HtmlDocumentRequest: Codable, Sendable {
    /// HTML template with field tags.
    /// Example: <p>Lorem Ipsum is simply dummy text of the <text-field name="Industry" role="First Party" required="false" style="width: 80px; height: 16px; display: inline-block; margin-bottom: -4px"> </text-field> and typesetting industry</p>
    public let html: String
    /// Document name. Random uuid will be assigned when not specified.
    /// Example: Test Document
    public let name: String?

    public init(html: String, name: String? = nil) {
        self.html = html
        self.name = name
    }
}

// MARK: - Create Template from PDF

public struct CreateTemplateFromPdfRequest: Codable, Sendable {
    /// Name of the template
    /// Example: Test PDF
    public let name: String?
    /// The folder's name to which the template should be created.
    public let folderName: String?
    /// Your application-specific unique string key to identify this template within your app. Existing template with specified `external_id` will be updated with a new PDF.
    /// Example: unique-key
    public let externalId: String?
    /// Set to `true` to make the template available via a shared link. This will allow anyone with the link to create a submission from this template.
    public let sharedLink: Bool?
    /// Documents
    public let documents: [TemplateDocumentRequest]
    /// Remove PDF form fields from the document.
    /// Default: false
    public let flatten: Bool
    /// Pass `false` to disable the removal of {{text}} tags from the PDF. This can be used along with transparent text tags for faster and more robust PDF processing.
    /// Default: true
    public let removeTags: Bool

    /// The API endpoint provides the functionality to create a fillable document template for existing PDF file. Use {{Field Name;role=Signer1;type=date}} text tags to define fillable fields in the document. See https://www.docuseal.com/examples/fieldtags.pdf for more text tag formats. Or specify the exact pixel coordinates of the document fields using `fields` param.
    /// Related Guides
    /// Use embedded text field tags to create a fillable form
    public init(
        name: String? = nil,
        folderName: String? = nil,
        externalId: String? = nil,
        sharedLink: Bool? = nil,
        documents: [TemplateDocumentRequest],
        flatten: Bool = false,
        removeTags: Bool = true
    ) {
        self.name = name
        self.folderName = folderName
        self.externalId = externalId
        self.sharedLink = sharedLink
        self.documents = documents
        self.flatten = flatten
        self.removeTags = removeTags
    }

    enum CodingKeys: String, CodingKey {
        case name
        case folderName = "folder_name"
        case externalId = "external_id"
        case sharedLink = "shared_link"
        case documents
        case flatten
        case removeTags = "remove_tags"
    }
}

// MARK: - Merge Templates

public struct MergeTemplatesRequest: Codable, Sendable {
    /// An array of template ids to merge into a new template.
    /// Example: [321,432]
    public let templateIds: [Int]
    /// Template name. Existing name with (Merged) suffix will be used if not specified.
    /// Example: Merged Template
    public let name: String?
    /// The name of the folder in which the merged template should be placed.
    public let folderName: String?
    /// Your application-specific unique string key to identify this template within your app.
    public let externalId: String?
    /// An array of submitter role names to be used in the merged template.
    /// Example: ["Agent","Customer"]
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

public struct UpdateTemplateRequest: Codable, Sendable {
    /// The name of the template
    /// Example: New Document Name
    public let name: String?
    /// The folder's name to which the template should be moved.
    /// Example: New Folder
    public let folderName: String?
    /// An array of submitter role names to update the template with.
    /// Example: ["Agent","Customer"]
    public let roles: [String]?
    /// Set `false` to unarchive template.
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

public struct UpdateTemplateDocumentsRequest: Codable, Sendable {
    /// The list of documents to add or replace in the template.
    public let documents: [UpdateTemplateDocumentRequest]
    /// Set to `true` to merge all existing and new documents into a single PDF document in the template.
    /// Default: false
    public let merge: Bool

    public init(
        documents: [UpdateTemplateDocumentRequest],
        merge: Bool = false
    ) {
        self.documents = documents
        self.merge = merge
    }
}

public struct UpdateTemplateDocumentRequest: Codable, Sendable {
    /// Document name. Random uuid will be assigned when not specified.
    /// Example: Test Template
    public let name: String?
    /// Base64-encoded content of the PDF or DOCX file or downloadable file URL. Leave it empty if you create a new document using HTML param.
    public let file: String?
    /// HTML template with field tags. Leave it empty if you add a document via PDF or DOCX base64 encoded file param or URL.
    public let html: String?
    /// Position of the document. By default will be added as the last document in the template.
    /// Example: 0
    public let position: Int?
    /// Set to `true` to replace existing document with a new file at `position`. Existing document fields will be transferred to the new document if it doesn't contain any fields.
    /// Default: false
    public let replace: Bool
    /// Set to `true` to remove existing document at given `position` or with given `name`.
    /// Default: false
    public let remove: Bool

    public init(
        name: String? = nil,
        file: String? = nil,
        html: String? = nil,
        position: Int? = nil,
        replace: Bool = false,
        remove: Bool = false
    ) {
        self.name = name
        self.file = file
        self.html = html
        self.position = position
        self.replace = replace
        self.remove = remove
    }
}
