//
//  DocuSealClient.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import AsyncHTTPClient
import Foundation
import JWTKit
import Logging
import NIOFoundationCompat
import NIOHTTP1

import struct NIOCore.TimeAmount

public struct DocuSealClient: Sendable {
    private let httpClient: HTTPClient
    internal var baseURL: String
    private var apiKey: String
    private let logger: Logger
    private var timeout: TimeAmount
    private let userAgent: String = "DocuSeal Swift SDK/1.0"

    internal var keys: JWTKeyCollection

    public init(
        baseURL: String = "https://api.docuseal.com",
        apiKey: String,
        httpClient: HTTPClient = HTTPClient.shared,
        logger: Logger = Logger(label: "com.docusealkit.DocuSealClient"),
        timeout: TimeAmount = .seconds(60)
    ) async {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.httpClient = httpClient
        self.logger = logger
        self.timeout = timeout
        self.keys = await JWTKeyCollection().add(hmac: .init(from: apiKey), digestAlgorithm: .sha256)
    }

    // MARK: - Configuration

    /// Configure the client with new settings
    public mutating func configure(
        baseURL: String? = nil,
        apiKey: String? = nil,
        timeout: TimeAmount? = nil
    ) async {
        if let baseURL = baseURL {
            self.baseURL = baseURL
        }

        if let apiKey = apiKey {
            self.apiKey = apiKey
            self.keys = await JWTKeyCollection().add(hmac: .init(from: apiKey), digestAlgorithm: .sha256)
        }

        if let timeout = timeout {
            self.timeout = timeout
        }
    }

    // MARK: - Helper Methods

    internal func makeRequest(
        path: String,
        method: HTTPMethod
    ) -> HTTPClientRequest {
        var request = HTTPClientRequest(url: "\(baseURL)\(path)")
        request.method = method
        request.headers.add(name: "X-Auth-Token", value: apiKey)
        request.headers.add(name: "Content-Type", value: "application/json")
        request.headers.add(name: "Accept", value: "application/json")
        request.headers.add(name: "User-Agent", value: userAgent)
        return request
    }

    internal func makeRequest<T: Encodable>(
        path: String,
        method: HTTPMethod,
        body: T
    ) throws -> HTTPClientRequest {
        var request = HTTPClientRequest(url: "\(baseURL)\(path)")
        request.method = method
        request.headers.add(name: "X-Auth-Token", value: apiKey)
        request.headers.add(name: "Content-Type", value: "application/json")
        request.headers.add(name: "Accept", value: "application/json")
        request.headers.add(name: "User-Agent", value: userAgent)

        do {
            let body = try JSONEncoder.docuSealEncoder.encode(body)
            request.body = .bytes(body)
        } catch {
            logger.error("Failed to encode request body: \(error)")
            throw DocuSealError.encodingError(message: String(describing: error))
        }

        return request
    }

    internal func executeRequest<T: Decodable>(_ request: HTTPClientRequest) async throws -> T {
        let response = try await httpClient.execute(request, timeout: timeout)
        // Try to get the expected bytes if not availbale collect upto 5mb
        let expectedBytes = response.headers.first(name: "content-length").flatMap(Int.init) ?? 05 * 1024 * 1024
        guard (200...299).contains(response.status.code) else {
            let body = try await response.body.collect(upTo: expectedBytes)  // 1MB max
            let error = String(buffer: body)
            logger.error("API request failed with status: \(response.status.code), error: \(error)")
            throw DocuSealError.httpError(statusCode: response.status.code, message: error)
        }

        do {
            let body = try await response.body.collect(upTo: expectedBytes)  // 5MB max
            return try JSONDecoder.docuSealDecoder.decode(T.self, from: Data(body.readableBytesView))
        } catch {
            logger.error("Failed to decode response: \(error)")
            throw DocuSealError.decodingError(message: String(describing: error))
        }
    }

    // MARK: - Internal Helpers
    internal struct AnyEncodable: Encodable {
        let value: Any

        init(_ value: Any) {
            self.value = value
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch value {
            case let value as String: try container.encode(value)
            case let value as Int: try container.encode(value)
            case let value as Double: try container.encode(value)
            case let value as Bool: try container.encode(value)
            case let value as [String: Any]: try container.encode(value.mapValues(AnyEncodable.init))
            case let value as [Any]: try container.encode(value.map(AnyEncodable.init))
            case is NSNull: try container.encodeNil()
            case Optional<Any>.none: try container.encodeNil()
            default:
                throw EncodingError.invalidValue(
                    value,
                    EncodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Invalid value type: \(type(of: value))"
                    )
                )
            }
        }
    }
}
