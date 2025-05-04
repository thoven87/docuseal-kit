//
//  DocuSealClient+Templates.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//
import struct Foundation.Date
import struct Foundation.URL
import struct Foundation.URLQueryItem

// MARK: Templates
extension DocuSealClient {
  /// List all templates
  public func listTemplates(query: TemplateListQuery? = nil) async throws -> TemplateListResponse {
    var path = "/templates"

    if let query = query {
      let queryItems = query.queryItems.map { "\($0.name)=\($0.value ?? "")" }
      if !queryItems.isEmpty {
        path += "?" + queryItems.joined(separator: "&")
      }
    }

    let request = makeRequest(path: path, method: .GET)
    return try await executeRequest(request)
  }

  /// Get a template by ID
  public func getTemplate(id: Int) async throws -> Template {
    let request = makeRequest(path: "/templates/\(id)", method: .GET)
    return try await executeRequest(request)
  }

  /// Create a template from Word DOCX
  public func createTemplateFromDocx(request: CreateTemplateFromDocxRequest) async throws
    -> Template
  {
    let httpRequest = try makeRequest(path: "/templates/docx", method: .POST, body: request)
    return try await executeRequest(httpRequest)
  }

  /// Create a template from HTML
  public func createTemplateFromHtml(request: CreateTemplateFromHtmlRequest) async throws
    -> Template
  {
    let httpRequest = try makeRequest(path: "/templates/html", method: .POST, body: request)
    return try await executeRequest(httpRequest)
  }

  /// Create a template from existing PDF
  public func createTemplateFromPdf(request: CreateTemplateFromPdfRequest) async throws -> Template
  {
    let httpRequest = try makeRequest(path: "/templates/pdf", method: .POST, body: request)
    return try await executeRequest(httpRequest)
  }

  /// Merge multiple templates into a new template
  public func mergeTemplates(request: MergeTemplatesRequest) async throws -> Template {
    let httpRequest = try makeRequest(path: "/templates/merge", method: .POST, body: request)
    return try await executeRequest(httpRequest)
  }

  /// Clone a template
  public func cloneTemplate(
    id: Int, name: String? = nil, folderName: String? = nil, externalId: String? = nil
  ) async throws -> Template {
    let request = try makeRequest(
      path: "/templates/\(id)/clone",
      method: .POST,
      body: [
        "name": name as Any,
        "folder_name": folderName as Any,
        "external_id": externalId as Any,
      ].compactMapValues { $0 as? AnyEncodable }
    )
    return try await executeRequest(request)
  }

  /// Update a template
  public func updateTemplate(id: Int, request: UpdateTemplateRequest) async throws
    -> UpdatedTemplateResponse
  {
    let httpRequest = try makeRequest(path: "/templates/\(id)", method: .PUT, body: request)
    return try await executeRequest(httpRequest)
  }

  /// Update template documents
  public func updateTemplateDocuments(id: Int, request: UpdateTemplateDocumentsRequest) async throws
    -> Template
  {
    let httpRequest = try makeRequest(
      path: "/templates/\(id)/documents", method: .PUT, body: request)
    return try await executeRequest(httpRequest)
  }

  /// Archive a template
  public func archiveTemplate(id: Int) async throws -> ArchiveResponse {
    let request = makeRequest(path: "/templates/\(id)", method: .DELETE)
    return try await executeRequest(request)
  }

  // MARK: - Additional Response Models

  public struct UpdatedTemplateResponse: Codable {
    public let id: Int
    public let updatedAt: Date

    public init(id: Int, updatedAt: Date) {
      self.id = id
      self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
      case id
      case updatedAt = "updated_at"
    }
  }
}
