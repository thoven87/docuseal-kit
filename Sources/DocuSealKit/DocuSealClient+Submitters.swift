//
//  DocuSealClient+Submitters.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

// MARK: Submitters
extension DocuSealClient {
    /// List all submitters
    public func listSubmitters(query: SubmitterListQuery? = nil) async throws -> SubmitterListResponse {
        var path = "/submitters"

        if let query = query {
            let queryItems = query.queryItems.map { "\($0.name)=\($0.value ?? "")" }
            if !queryItems.isEmpty {
                path += "?" + queryItems.joined(separator: "&")
            }
        }

        let request = makeRequest(path: path, method: .GET)
        return try await executeRequest(request)
    }

    /// Get a submitter by ID
    public func getSubmitter(id: Int, query: SubmitterQuery? = nil) async throws -> Submitter {
        var path = "/submitters/\(id)"

        if let query = query {
            let queryItems = query.queryItems.map { "\($0.name)=\($0.value ?? "")" }
            if !queryItems.isEmpty {
                path += "?" + queryItems.joined(separator: "&")
            }
        }

        let request = makeRequest(path: path, method: .GET)
        return try await executeRequest(request)
    }

    /// Update a submitter
    public func updateSubmitter(id: Int, request: UpdateSubmitterRequest) async throws -> Submitter {
        let httpRequest = try makeRequest(path: "/submitters/\(id)", method: .PUT, body: request)
        return try await executeRequest(httpRequest)
    }
}
