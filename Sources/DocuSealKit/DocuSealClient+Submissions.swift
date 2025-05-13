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
    public func getSubmission(id: Int) async throws -> Submission {
        let request = makeRequest(path: "/submissions/\(id)", method: .GET)
        return try await executeRequest(request)
    }

    /// Get submission documents
    public func getSubmissionDocuments(id: Int) async throws -> SubmissionDocuments {
        let request = makeRequest(path: "/submissions/\(id)/documents", method: .GET)
        return try await executeRequest(request)
    }

    /// Create a submission
    public func createSubmission(request: CreateSubmissionRequest) async throws -> [Submitter] {
        let httpRequest = try makeRequest(path: "/submissions", method: .POST, body: request)
        return try await executeRequest(httpRequest)
    }

    /// Create submissions from emails
    public func createSubmissionsFromEmails(
        request: CreateSubmissionsFromEmailsRequest
    ) async throws -> [Submitter] {
        let httpRequest = try makeRequest(path: "/submissions/emails", method: .POST, body: request)
        return try await executeRequest(httpRequest)
    }

    /// Archive a submission
    public func archiveSubmission(id: Int) async throws -> ArchiveResponse {
        let request = makeRequest(path: "/submissions/\(id)", method: .DELETE)
        return try await executeRequest(request)
    }
}
