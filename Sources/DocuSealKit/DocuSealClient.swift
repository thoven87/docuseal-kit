//
//  DocuSealClient.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import AsyncHTTPClient
import Foundation
import Logging
import NIOCore
import NIOHTTP1

public struct DocuSealClient {
    private let httpClient: HTTPClient
    private let baseURL: String
    private let apiKey: String
    private let logger: Logger
    private let timeout: TimeAmount
    private let userAgent: String = "DocuSeal Swift SDK/1.0"

    public init(
        baseURL: String = "https://api.docuseal.com",
        apiKey: String,
        httpClient: HTTPClient = HTTPClient.shared,
        logger: Logger = Logger(label: "com.docuseal.kit"),
        timeout: TimeAmount = .seconds(60)
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.httpClient = httpClient
        self.logger = logger
        self.timeout = timeout
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
            let bodyData = try JSONEncoder.docuSealEncoder.encode(body)
            request.body = .bytes(ByteBuffer(data: bodyData))
        } catch {
            logger.error("Failed to encode request body: \(error)")
            throw DocuSealError.encodingError(message: String(describing: error))
        }

        return request
    }

    internal func executeRequest<T: Decodable>(_ request: HTTPClientRequest) async throws -> T {
        let response = try await httpClient.execute(request, timeout: timeout)

        guard (200...299).contains(response.status.code) else {
            let body = try await response.body.collect(upTo: 1024 * 1024)  // 1MB max
            let error = String(buffer: body)
            logger.error("API request failed with status: \(response.status.code), error: \(error)")
            throw DocuSealError.httpError(statusCode: response.status.code, message: error)
        }

        do {
            let body = try await response.body.collect(upTo: 5 * 1024 * 1024)  // 5MB max
            return try JSONDecoder.docuSealDecoder.decode(T.self, from: Data(buffer: body))
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
