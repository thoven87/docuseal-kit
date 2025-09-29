//
//  DocuSealClient+Submissions.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

// MARK: Submissions
extension DocuSealClient {
    /// List all submissions
    public func listSubmissions(
        query: SubmissionListQuery? = nil
    ) async throws -> SubmissionListResponse {
        var path = "/submissions"

        if let query = query {
            let queryItems = query.queryItems.map { "\($0.name)=\($0.value ?? "")" }
            if !queryItems.isEmpty {
                path += "?" + queryItems.joined(separator: "&")
            }
        }

        let request = makeRequest(path: path, method: .GET)
        return try await executeRequest(request)
    }

    /// Get a submission by ID
    public func getSubmission(id: Int, query: SubmissionQuery? = nil) async throws -> Submission {
        var path = "/submissions/\(id)"

        if let query = query {
            let queryItems = query.queryItems.map { "\($0.name)=\($0.value ?? "")" }
            if !queryItems.isEmpty {
                path += "?" + queryItems.joined(separator: "&")
            }
        }

        let request = makeRequest(path: path, method: .GET)
        return try await executeRequest(request)
    }

    /// Get submission documents
    public func getSubmissionDocuments(id: Int, query: SubmissionDocumentsQuery? = nil) async throws -> SubmissionDocuments {
        var path = "/submissions/\(id)/documents"

        if let query = query {
            let queryItems = query.queryItems.map { "\($0.name)=\($0.value ?? "")" }
            if !queryItems.isEmpty {
                path += "?" + queryItems.joined(separator: "&")
            }
        }

        let request = makeRequest(path: path, method: .GET)
        return try await executeRequest(request)
    }

    /// Create a submission
    public func createSubmission(request: CreateSubmissionRequest) async throws -> CreateSubmissionResponse {
        let httpRequest = try makeRequest(path: "/submissions/init", method: .POST, body: request)
        return try await executeRequest(httpRequest)
    }

    /// Create submissions from emails
    public func createSubmissionsFromEmails(
        request: CreateSubmissionsFromEmailsRequest
    ) async throws -> [Submitter] {
        let httpRequest = try makeRequest(path: "/submissions/emails", method: .POST, body: request)
        return try await executeRequest(httpRequest)
    }

    /// Create submission from PDF
    public func createSubmissionFromPdf(
        request: CreateSubmissionFromPdfRequest
    ) async throws -> CreateSubmissionResponse {
        let httpRequest = try makeRequest(path: "/submissions/pdf", method: .POST, body: request)
        return try await executeRequest(httpRequest)
    }

    /// Create submission from HTML
    public func createSubmissionFromHtml(
        request: CreateSubmissionFromHtmlRequest
    ) async throws -> CreateSubmissionResponse {
        let httpRequest = try makeRequest(path: "/submissions/html", method: .POST, body: request)
        return try await executeRequest(httpRequest)
    }

    /// Create submission from DOCX
    public func createSubmissionFromDocx(
        request: CreateSubmissionFromDocxRequest
    ) async throws -> CreateSubmissionResponse {
        let httpRequest = try makeRequest(path: "/submissions/docx", method: .POST, body: request)
        return try await executeRequest(httpRequest)
    }

    /// Archive a submission
    public func archiveSubmission(id: Int) async throws -> ArchiveResponse {
        let request = makeRequest(path: "/submissions/\(id)", method: .DELETE)
        return try await executeRequest(request)
    }

    /// Permanently delete a submission
    public func permanentlyDeleteSubmission(id: Int) async throws -> ArchiveResponse {
        var request = makeRequest(path: "/submissions/\(id)", method: .DELETE)
        request.url = "\(baseURL)/submissions/\(id)?permanently=true"
        return try await executeRequest(request)
    }
}
