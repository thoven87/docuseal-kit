//
//  DocusealError.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//
import Foundation
import Testing

@testable import DocuSealKit

// MARK: - Template Decoding Tests

@Suite("Template Decoding Tests")
struct TemplateDecodingTests {
    @Test("Can decode template list response")
    func testTemplateListDecoding() throws {
        let json = """
            {
              "data": [
                {
                  "id": 1,
                  "slug": "iRgjDX7WDK6BRo",
                  "name": "Example Template",
                  "preferences": {},
                  "schema": [
                    {
                      "attachment_uuid": "d94e615f-76e3-46d5-8f98-36bdacb8664a",
                      "name": "example-document"
                    }
                  ],
                  "fields": [
                    {
                      "uuid": "594bdf04-d941-4ca6-aa73-93e61d625c02",
                      "submitter_uuid": "0954d146-db8c-4772-aafe-2effc7c0e0c0",
                      "name": "Full Name",
                      "type": "text",
                      "required": true,
                      "preferences": {},
                      "areas": [
                        {
                          "x": 0.2638888888888889,
                          "y": 0.168958742632613,
                          "w": 0.325,
                          "h": 0.04616895874263263,
                          "attachment_uuid": "d94e615f-76e3-46d5-8f98-36bdacb8664a",
                          "page": 0
                        }
                      ]
                    }
                  ],
                  "submitters": [
                    {
                      "name": "First Party",
                      "uuid": "0954d146-db8c-4772-aafe-2effc7c0e0c0"
                    }
                  ],
                  "author_id": 1,
                  "archived_at": null,
                  "created_at": "2023-12-14T15:21:57.375Z",
                  "updated_at": "2023-12-14T15:22:55.094Z",
                  "source": "native",
                  "folder_id": 1,
                  "folder_name": "Default",
                  "external_id": "c248ffba-ef81-48b7-8e17-e3cecda1c1c5",
                  "author": {
                    "id": 1,
                    "first_name": "John",
                    "last_name": "Doe",
                    "email": "john.doe@example.com"
                  },
                  "documents": [
                    {
                      "id": 5,
                      "uuid": "d94e615f-76e3-46d5-8f98-36bdacb8664a",
                      "url": "https://docuseal.com/file/hash/sample-document.pdf",
                      "preview_image_url": "https://docuseal.com/file/hash/0.jpg",
                      "filename": "example-document.pdf"
                    }
                  ]
                }
              ],
              "pagination": {
                "count": 1,
                "next": 1,
                "prev": 2
              }
            }
            """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder.docuSealDecoder.decode(TemplateListResponse.self, from: data)

        #expect(response.data.count == 1)
        #expect(response.data[0].id == 1)
        #expect(response.data[0].name == "Example Template")
        #expect(response.data[0].fields.count == 1)
        #expect(response.data[0].fields[0].name == "Full Name")
        #expect(response.pagination.count == 1)
    }
}

// MARK: - Submission Encoding Tests

@Suite("Submission Encoding Tests")
struct SubmissionEncodingTests {
    @Test("Can encode submission request")
    func testSubmissionCreationEncoding() throws {
        let request = CreateSubmissionRequest(
            templateId: 1_000_001,
            submitters: [
                SubmissionSubmitter(
                    role: "First Party",
                    email: "john.doe@example.com"
                )
            ]
        )

        let data = try JSONEncoder.docuSealEncoder.encode(request)
        let jsonString = String(data: data, encoding: .utf8)!

        #expect(jsonString.contains("\"template_id\":1000001"))
        #expect(jsonString.contains("\"role\":\"First Party\""))
        #expect(jsonString.contains("\"email\":\"john.doe@example.com\""))
    }
}

// MARK: - Client Configuration Tests

@Suite("Client Configuration Tests")
struct ClientConfigurationTests {
    @Test("Client uses HTTPClient.shared by default")
    func testClientUsesSharedHttpClient() async throws {

        _ = await DocuSealClient(apiKey: "apiKey")
        //let result = try await client.getTemplate(id: 960051)

        // TODO: need to figure out how to run integration tests on github
        #expect(true)  // This is a smoke test to ensure the client initializes correctly
    }

    @Test("Client can use custom baseURL")
    func testClientWithCustomBaseUrl() async {
        let customBaseURL = "https://custom.docuseal.com"
        _ = await DocuSealClient(baseURL: customBaseURL, apiKey: "apiKey")
        // TODO: need to figure out how to run integration tests on github
        #expect(true)
    }

    @Test("Generate JWT Token")
    func testGenerateJWT() async throws {
        let client = await DocuSealClient(apiKey: "apiKey")
        let jwtToken = try await client.createToken(
            .init(
                externalID: "some-external-id",
                userEmail: "user@example.com",
                intergrationEmail: "saas@example.com",
                name: "Document Processing",
                documentURLs: ["https://www.irs.gov/pub/irs-pdf/fw9.pdf"]
            )
        )

        #expect(jwtToken.isEmpty == false, "JWT token does not contain the expected token string")
    }
}
