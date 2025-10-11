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
                      "attachment_uuid": "d94e615f-76e3-46d5-8f98-36bdssb8664a",
                      "name": "example-document"
                    }
                  ],
                  "fields": [
                    {
                      "uuid": "594bdf04-d941-4ca6-aa73-93e61d625c02",
                      "submitter_uuid": "0954d146-db8c-4772-etfe-2effc7c0e0c0",
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
                          "attachment_uuid": "d94e629f-76e3-46d5-8f98-36bdacb8664a",
                          "page": 0
                        }
                      ]
                    }
                  ],
                  "submitters": [
                    {
                      "name": "First Party",
                      "uuid": "0954d146-db8c-5072-aafe-2effc7c0e0c0"
                    }
                  ],
                  "author_id": 1,
                  "archived_at": null,
                  "created_at": "2023-12-14T15:21:57.375Z",
                  "updated_at": "2023-12-14T15:22:55.094Z",
                  "source": "native",
                  "folder_id": 1,
                  "folder_name": "Default",
                  "external_id": "c248ffba-ef90-48b7-8e17-e3cecda1c1c5",
                  "author": {
                    "id": 1,
                    "first_name": "John",
                    "last_name": "Doe",
                    "email": "john.doe@example.com"
                  },
                  "documents": [
                    {
                      "id": 5,
                      "uuid": "d94e615f-76e3-49d5-8f98-36bdacb8664a",
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

    @Test("Generate JWT Token")
    func testGenerateJWT() async throws {
        let client = await DocuSealClient(apiKey: "apiKey")
        let jwtToken = try await client.createToken(
            .init(
                externalID: "some-external-id",
                userEmail: "user@example.com",
                intergrationEmail: "saas@example.com",
                templateName: "Document Processing",
                documentURLs: ["https://www.irs.gov/pub/irs-pdf/fw9.pdf"]
            )
        )

        #expect(jwtToken.isEmpty == false, "JWT token does not contain the expected token string")
    }

    @Test("Webhook Submission Decoding Event")
    func testWebhookSubmissionDecodingEvent() throws {
        let json = """
            {
                "event_type": "form.completed",
                "timestamp": "2025-05-12T01:57:04Z",
                "data": {
                  "id": 2528210,
                  "submission_id": 1905777,
                  "email": "me@gmail.com",
                  "phone": null,
                  "name": "Debby Linx",
                  "ua": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1",
                  "ip": "26.107.118.104",
                  "sent_at": "2025-05-10T22:48:53.956Z",
                  "opened_at": "2025-05-10T22:55:34.170Z",
                  "completed_at": "2025-05-10T22:55:51.675Z",
                  "created_at": "2025-05-10T22:48:53.959Z",
                  "updated_at": "2025-05-10T22:55:51.701Z",
                  "external_id": null,
                  "metadata": {},
                  "status": "completed",
                  "application_key": null,
                  "decline_reason": null,
                  "preferences": {
                    "send_email": true,
                    "send_sms": false
                  },
                  "values": [
                    {
                      "field": "First person",
                      "value": "https://docuseal.com/blobs_proxy/PYt1Yzk3NTNjYS1mODBiLTQ5NjUtOTI0OS1iMTc1MzUxNTVhMDgiLCJibG9iIl0=--af94866daafabbd479a164bbf56b43d50f065d5403e2e30f83c563ae27d0ada4/signature.png"
                    }
                  ],
                  "role": "Self",
                  "documents": [
                    {
                      "name": "32bd7bdc-522c-70f8-b549-fbfac245f637",
                      "url": "https://docuseal.com/blobs_proxy/QRW0ZTM3ZGE3ZC1mYjgxLTQ3YzQtYjQ1Yi03OTk2MzgwOWYwNGQiLCJibG9iIl0=--5bd961233a9cd8ff94924c8e724d99ef228a1e24808ef8a66f6d6193364f7571/32bd7bdc-522c-45f8-b549-fbfac245f637.pdf"
                    }
                  ],
                  "audit_log_url": "https://docuseal.com/blobs_proxy/JYTjNWZjYmM1NC01YWYwLTQ2ZGUtYWIxZC04YWFiZmFlOTEzYjkiLCJibG9iIl0=--4cfb30902ec12cfb8aac5392aa642874f8455d6680e091bf9c981d0c0e5843ee/Audit%20Log%20-%20google-doc-document.pdf.pdf",
                  "submission_url": "https://docuseal.com/e/PR9uf5x64vogAz",
                  "template": {
                    "id": 1025725,
                    "name": "google-doc-document.pdf",
                    "external_id": "0196b5c9-dc6b-7c90-97e4-92a8dbe6add2",
                    "created_at": "2025-05-09T16:04:51.932Z",
                    "updated_at": "2025-05-10T03:40:58.951Z",
                    "folder_name": "ACH Health"
                  },
                  "submission": {
                    "id": 1905777,
                    "created_at": "2025-05-10T22:48:53.957Z",
                    "audit_log_url": "https://docuseal.com/blobs_proxy/WyYreWZjYmM1NC01YWYwLTQ2ZGUtYWIxZC04YWFiZmFlOTEzYjkiLCJibG9iIl0=--4cfb30902ec12cfb8aac5392aa642874f8455d6680e091bf9c981d0c0e5843ee/Audit%20Log%20-%20google-doc-document.pdf.pdf",
                    "combined_document_url": "https://docuseal.com/blobs_proxy/WyPTrZGRlYWI4NC1hYzQwLTRhZDktOTFmOC02YTA3NmRhOTk3ZTQiLCJibG9iIl0=--d367cc9eba5cb7be241d4ef64e0772e76632be6b31ece0df1d4ec932d92c466c/google-doc-document.pdf.pdf",
                    "status": "completed",
                    "url": "https://docuseal.com/e/Kz9uf5x75vogAz"
                  }
                }
              }
            """
        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealFormWebhookEvent.self, from: data)

        // Validate webhook event structure
        #expect(webhook.eventType == .formCompleted)
        #expect(webhook.data.id == 2_528_210)
        #expect(webhook.data.submissionId == 1_905_777)
        #expect(webhook.data.email == "me@gmail.com")
        #expect(webhook.data.name == "Debby Linx")
        #expect(webhook.data.role == "Self")
        #expect(webhook.data.status == .completed)

        // Validate template data
        #expect(webhook.data.template?.id == 1_025_725)
        #expect(webhook.data.template?.name == "google-doc-document.pdf")
        #expect(webhook.data.template?.externalId == "0196b5c9-dc6b-7c90-97e4-92a8dbe6add2")
        #expect(webhook.data.template?.folderName == "ACH Health")

        // Validate submission data
        #expect(webhook.data.submission?.id == 1_905_777)
        #expect(webhook.data.submission?.status == .completed)

        // Validate field values
        #expect(webhook.data.values?.count == 1)
        #expect(webhook.data.values?.first?.field == "First person")
        #expect(webhook.data.values?.first?.value.contains("signature.png") == true)

        // Validate documents
        #expect(webhook.data.documents?.count == 1)
        #expect(webhook.data.documents?.first?.name == "32bd7bdc-522c-70f8-b549-fbfac245f637")

        // Validate preferences
        #expect(webhook.data.preferences?.sendEmail == true)
        #expect(webhook.data.preferences?.sendSms == false)
    }

    @Test("Without audit logging")
    func testSansAuditLogging() throws {
        let json = """
            {
                "event_type": "form.completed",
                "timestamp": "2025-05-13T02:19:11Z",
                "data": {
                  "id": 2548399,
                  "submission_id": 1920711,
                  "email": "docuseal@test.io",
                  "phone": null,
                  "name": "Docuseal",
                  "ua": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Safari/605.1.15",
                  "ip": "81.117.128.204",
                  "sent_at": "2025-05-13T02:15:14.000Z",
                  "opened_at": "2025-05-13T02:15:44.000Z",
                  "completed_at": "2025-05-13T02:15:54.000Z",
                  "created_at": "2025-05-13T02:15:14.000Z",
                  "updated_at": "2025-05-13T02:15:54.000Z",
                  "external_id": null,
                  "metadata": {},
                  "status": "completed",
                  "application_key": null,
                  "decline_reason": null,
                  "preferences": {
                    "send_email": true,
                    "send_sms": false
                  },
                  "values": [
                    {
                      "field": "Neighbor",
                      "value": "https://docuseal.com/blobs_proxy/MYR1YmU1NDgzMS01NTk2LTRlNjYtYTg5MC1iMTA0YTFmMjY0NmYiLCJibG9iIl0=--3bf0fd705af5bc4f1ba38305c9f5c7ae9f63a7ab2e3815f1ba42e063d0e1686c/initials.png"
                    },
                    {
                      "field": "Neighbor",
                      "value": "https://docuseal.com/blobs_proxy/MYR5YWQ1ZDgyYi0yODVlLTQwNjItYjhhMC03N2M3NDVkMDBiZTAiLCJibG9iIl0=--08849dea8c7b4fa6ac9844fa40ee157dd813b7566623477893ecd1a3e0912e90/signature.png"
                    }
                  ],
                  "role": "Neighbor",
                  "documents": [
                    {
                      "name": "8c9ef2ca-0bee-464d-b101-e98f55c71482",
                      "url": "https://docuseal.com/blobs_proxy/WyI1MHReZTBhMy1kZTBiLTRkZDctYmYzZC0zNDMyODcyNjczNmEiLCJibG9iIl0=--8b660765289b486a10df8f2de3725e2e2371568a1ec9a9a03bb358338691c03b/8c9ef2ca-0bee-464d-b101-e74f55c71482.pdf"
                    }
                  ],
                  "audit_log_url": null,
                  "submission_url": "https://docuseal.com/e/Y9zAlUnv8ZDnXS",
                  "template": {
                    "id": 1037778,
                    "name": "Abstract-2025-05-12-220647",
                    "external_id": "0196c746-1042-793f-a400-54ddd1db8817",
                    "created_at": "2025-05-13T02:06:48.000Z",
                    "updated_at": "2025-05-13T02:15:08.000Z",
                    "folder_name": "ACH Health/Abstract"
                  },
                  "submission": {
                    "id": 1920711,
                    "created_at": "2025-05-13T02:15:14.000Z",
                    "audit_log_url": null,
                    "combined_document_url": null,
                    "status": "pending",
                    "url": "https://docuseal.com/e/Y9HSYUnv8ZDnXS"
                  }
                }
              }
            """

        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealFormWebhookEvent.self, from: data)

        // Validate basic webhook structure
        #expect(webhook.eventType == .formCompleted)
        #expect(webhook.data.id == 2_548_399)
        #expect(webhook.data.submissionId == 1_920_711)
        #expect(webhook.data.email == "docuseal@test.io")
        #expect(webhook.data.name == "Docuseal")
        #expect(webhook.data.role == "Neighbor")
        #expect(webhook.data.status == .completed)

        // Validate null audit log handling
        #expect(webhook.data.auditLogUrl == nil)
        #expect(webhook.data.submission?.auditLogUrl == nil)
        #expect(webhook.data.submission?.combinedDocumentUrl == nil)

        // Validate multiple field values
        #expect(webhook.data.values?.count == 2)
        let values = webhook.data.values ?? []
        #expect(values.allSatisfy { $0.field == "Neighbor" })
        #expect(values.first?.value.contains("initials.png") == true)
        #expect(values.last?.value.contains("signature.png") == true)

        // Validate template with subfolder
        #expect(webhook.data.template?.folderName == "ACH Health/Abstract")
        #expect(webhook.data.template?.externalId == "0196c746-1042-793f-a400-54ddd1db8817")
    }

    @Test("Template updated")
    func templateUpdated() throws {
        let json = """
            {
              "event_type": "template.updated",
              "timestamp": "2025-05-13T02:14:42.103Z",
              "data": {
                "id": 1037778,
                "archived_at": null,
                "fields": [
                  {
                    "uuid": "0bff0bdc-16fc-4f07-80af-eeae1cd35486",
                    "submitter_uuid": "2a8560e3-0d3f-45ba-8107-a87fc62895d1",
                    "name": "Neighbor",
                    "type": "initials",
                    "required": true,
                    "preferences": {},
                    "areas": [
                      {
                        "x": 0.06148867313915857,
                        "y": 0.8090075062552127,
                        "w": 0.162891046386192,
                        "h": 0.01834862385321101,
                        "attachment_uuid": "d9ac7e43-7a33-4690-bdef-ec28b637026c",
                        "page": 0
                      }
                    ]
                  },
                  {
                    "uuid": "1167bc04-11dd-4302-a5fe-ee3c5ace9208",
                    "submitter_uuid": "2a8560e3-0d3f-45ba-8107-a87fc62895d1",
                    "name": "Neighbor",
                    "type": "signature",
                    "required": true,
                    "preferences": {},
                    "areas": [
                      {
                        "x": 0.0226537216828479,
                        "y": 0.9313085512514822,
                        "w": 0.2632146709816613,
                        "h": 0.06451209341117603,
                        "attachment_uuid": "d9ac7e43-7a33-4690-bdef-ec28b637026c",
                        "page": 0
                      }
                    ]
                  },
                  {
                    "uuid": "8e3af68d-25bb-4220-9e4c-b20028f26cce",
                    "submitter_uuid": "2a8560e3-0d3f-45ba-8107-a87fc62895d1",
                    "name": "Other Relative",
                    "type": "initials",
                    "required": true,
                    "preferences": {},
                    "areas": [
                      {
                        "x": 0.5393743257820928,
                        "y": 0.8081734778982486,
                        "w": 0.162891046386192,
                        "h": 0.01834862385321101,
                        "attachment_uuid": "d9ac7e43-7a33-4690-bdef-ec28b637026c",
                        "page": 0
                      }
                    ]
                  }
                ],
                "name": "Abstract-2025-05-12-220647",
                "preferences": {},
                "schema": [
                  {
                    "attachment_uuid": "d9ac7e43-7a33-4690-bdef-ec28b637026c",
                    "name": "8c9ef2ca-0bee-464d-b101-e74f55c71482"
                  }
                ],
                "slug": "KMARR98kxKria4",
                "source": "embed",
                "submitters": [
                  {
                    "name": "Neighbor",
                    "uuid": "2a8560e3-0d3f-45ba-8107-a87fc62895d1"
                  },
                  {
                    "name": "Other Relatives",
                    "uuid": "a2f73fdc-66c5-4b53-901f-2168621ec698"
                  }
                ],
                "created_at": "2025-05-13T02:06:48.087Z",
                "updated_at": "2025-05-13T02:14:42.092Z",
                "author_id": 64936,
                "external_id": "0196c746-1042-793f-a529-54ddd1db8817",
                "folder_id": 90851,
                "application_key": "0196c746-1042-793f-a529-54ddd1db8817",
                "folder_name": "ACH Health/Abstract",
                "author": {
                  "id": 64936,
                  "email": "dos@lemur.com",
                  "first_name": null,
                  "last_name": null
                },
                "documents": [
                  {
                    "id": 16013952,
                    "uuid": "d9ac7e43-7a33-4690-bdef-ec28b637026c",
                    "url": "https://docuseal.com/file/YHsjdsWY2YS1kYTgyLTQ3MDctOTRjZC00YzdmNTdmY2YyMzMiLCJibG9iIl0--ddac5798dd292e69bb588c946413837cbd7199f1771bc5773defc9cedfeaf86e/8c9ef2ca-0bee-464d-b101-e74f55c71482",
                    "preview_image_url": "https://docuseal.com/file/7ehejehsWZhMS01ODAwLTQ4NmYtYWJhNi0xYTY5YzMyYzY4ZDIiLCJibG9iIl0--111c29945943463dc95f982138deb4c671b3e53369ed8c482418f9994ed40ed5/0.png",
                    "filename": "8c9ef2ca-0bee-464d-b101-e90f55c71482"
                  }
                ]
              }
            }
            """

        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealTemplateWebhookEvent.self, from: data)

        // Validate webhook event structure
        #expect(webhook.eventType == .templateUpdated)
        #expect(webhook.data.id == 1_037_778)
        #expect(webhook.data.name == "Abstract-2025-05-12-220647")
        #expect(webhook.data.source == .embed)
        #expect(webhook.data.authorId == 64936)
        #expect(webhook.data.folderId == 90851)
        #expect(webhook.data.externalId == "0196c746-1042-793f-a529-54ddd1db8817")
        #expect(webhook.data.applicationKey == "0196c746-1042-793f-a529-54ddd1db8817")
        #expect(webhook.data.folderName == "ACH Health/Abstract")

        // Validate fields array
        #expect(webhook.data.fields.count == 3)
        let fields = webhook.data.fields
        #expect(fields[0].name == "Neighbor")
        #expect(fields[0].type == "initials")
        #expect(fields[0].required == true)
        #expect(fields[1].name == "Neighbor")
        #expect(fields[1].type == "signature")
        #expect(fields[2].name == "Other Relative")
        #expect(fields[2].type == "initials")

        // Validate submitters
        #expect(webhook.data.submitters.count == 2)
        #expect(webhook.data.submitters[0].name == "Neighbor")
        #expect(webhook.data.submitters[1].name == "Other Relatives")

        // Validate schema
        #expect(webhook.data.schema.count == 1)
        #expect(webhook.data.schema[0].attachmentUuid == "d9ac7e43-7a33-4690-bdef-ec28b637026c")
        #expect(webhook.data.schema[0].name == "8c9ef2ca-0bee-464d-b101-e74f55c71482")

        // Validate author
        #expect(webhook.data.author.id == 64936)
        #expect(webhook.data.author.email == "dos@lemur.com")
    }

    @Test("Template created")
    func templateCreated() throws {
        let json = """
            {"event_type":"template.created","timestamp":"2025-05-13T02:06:48.565Z","data":{"id":1037778,"archived_at":null,"fields":[],"name":"Abstract-2025-05-12-220647","preferences":{},"schema":[{"attachment_uuid":"d9ac7e43-7a33-4690-bdef-ec28b637026c","name":"8c9ef2ca-0bee-464d-b101-e74f55c71482"}],"slug":"KMARR98kxKria4","source":"embed","submitters":[{"name":"First Party","uuid":"2a8560e3-0d3f-45ba-8107-a87fc62895d1"}],"created_at":"2025-05-13T02:06:48.087Z","updated_at":"2025-05-13T02:06:48.557Z","author_id":64936,"external_id":"0196c746-3783-793f-a529-54ddd1db8817","folder_id":90851,"application_key":"0196c746-1042-793f-a529-54ddd1db8817","folder_name":"ACH Health/Abstract","author":{"id":64936,"email":"dos@lemur.com","first_name":null,"last_name":null},"documents":[{"id":16013952,"uuid":"d9ac7e43-7a33-4690-bdef-ec28b637026c","url":"https://docuseal.com/file/HSJShOWY2YS1kYTgyLTQ3MDctOTRjZC00YzdmNTdmY2YyMzMiLCJibG9iIl0--ddac5798dd292e69bb588c946413837cbd7199f1771bc5773defc9cedfeaf86e/8c9ef2ca-0bee-464d-b101-e74f55c71482","preview_image_url":"https://docuseal.com/file/WyIxNTkyOWZhMS01ODAwLTQ4NmYtYWJhNi0xYTY5YzMyYzY4ZDIiLCJibG9iIl0--111c29945943463dc95f982138deb4c671b3e53369ed8c482418f9994ed40ed5/0.png","filename":"8c9ef2ca-0bee-464d-b101-e74f55c71482"}]}}
            """

        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealTemplateWebhookEvent.self, from: data)

        // Validate webhook event structure
        #expect(webhook.eventType == .templateCreated)
        #expect(webhook.data.id == 1_037_778)
        #expect(webhook.data.name == "Abstract-2025-05-12-220647")
        #expect(webhook.data.slug == "KMARR98kxKria4")
        #expect(webhook.data.source == .embed)
        #expect(webhook.data.authorId == 64936)
        #expect(webhook.data.externalId == "0196c746-3783-793f-a529-54ddd1db8817")
        #expect(webhook.data.folderName == "ACH Health/Abstract")

        // Validate initial state (no fields yet)
        #expect(webhook.data.fields.count == 0)

        // Validate single submitter
        #expect(webhook.data.submitters.count == 1)
        #expect(webhook.data.submitters[0].name == "First Party")

        // Validate document
        #expect(webhook.data.documents.count == 1)
        let document = webhook.data.documents[0]
        #expect(document.id == 16_013_952)
        #expect(document.uuid == "d9ac7e43-7a33-4690-bdef-ec28b637026c")
        #expect(document.filename == "8c9ef2ca-0bee-464d-b101-e74f55c71482")
        #expect(document.url.contains("docuseal.com/file"))
        #expect(document.previewImageUrl?.contains("0.png") == true)
    }

    @Test("Submission created")
    func testSubmissionCreated() throws {
        let json = """
            {
              "event_type": "submission.created",
              "timestamp": "2025-05-13T02:11:37.515Z",
              "data": {
                "id": 1920701,
                "slug": "naCiW4G3aR8hB5",
                "source": "embed",
                "submitters_order": "preserved",
                "expire_at": null,
                "created_at": "2025-05-13T02:11:37.491Z",
                "updated_at": "2025-05-13T02:11:37.491Z",
                "archived_at": null,
                "audit_log_url": null,
                "combined_document_url": null,
                "submitters": [
                  {
                    "id": 2548387,
                    "slug": "8HSJS2mYj4RfEt",
                    "uuid": "2a8560e3-0d3f-56ba-8107-a87fc62895d1",
                    "name": "John Doe",
                    "email": "docuseal@test.io",
                    "phone": null,
                    "completed_at": null,
                    "declined_at": null,
                    "external_id": null,
                    "submission_id": 1920701,
                    "metadata": {},
                    "opened_at": null,
                    "sent_at": "2025-05-13T02:11:37.489Z",
                    "created_at": "2025-05-13T02:11:37.494Z",
                    "updated_at": "2025-05-13T02:11:37.494Z",
                    "status": "sent",
                    "application_key": null,
                    "values": [],
                    "documents": [],
                    "preferences": {
                      "send_email": true,
                      "send_sms": false
                    },
                    "role": "Neighbor"
                  },
                  {
                    "id": 2548388,
                    "slug": "B4dXGTTjbqcjWY",
                    "uuid": "a2f73fdc-70c5-4b53-901f-2168621ec698",
                    "name": "Liem",
                    "email": "lovely@example.com",
                    "phone": null,
                    "completed_at": null,
                    "declined_at": null,
                    "external_id": null,
                    "submission_id": 1920701,
                    "metadata": {},
                    "opened_at": null,
                    "sent_at": null,
                    "created_at": "2025-05-13T02:11:37.496Z",
                    "updated_at": "2025-05-13T02:11:37.496Z",
                    "status": "awaiting",
                    "application_key": null,
                    "values": [],
                    "documents": [],
                    "preferences": {
                      "send_email": true,
                      "send_sms": false
                    },
                    "role": "Other Relatives"
                  }
                ],
                "template": {
                  "id": 1037778,
                  "name": "Abstract-2025-05-12-220647",
                  "external_id": "0196c746-1042-793f-a529-54ddd1db8817",
                  "created_at": "2025-05-13T02:06:48.087Z",
                  "updated_at": "2025-05-13T02:11:22.974Z",
                  "folder_name": "ACH Health/Abstract"
                },
                "created_by_user": {
                  "id": 64936,
                  "email": "dos@lemur.com",
                  "first_name": null,
                  "last_name": null
                },
                "submission_events": [],
                "documents": [],
                "status": "pending",
                "completed_at": null
              }
            }
            """

        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealSubmissionWebhookEvent.self, from: data)

        // Validate webhook event structure
        #expect(webhook.eventType == .submissionCreated)
        #expect(webhook.data.id == 1_920_701)
        #expect(webhook.data.source == .embed)
        #expect(webhook.data.submittersOrder == .preserved)
        #expect(webhook.data.status == .pending)

        // Validate submitters
        #expect(webhook.data.submitters?.count == 2)
        let submitters = webhook.data.submitters ?? []
        #expect(submitters[0].id == 2_548_387)
        #expect(submitters[0].email == "docuseal@test.io")
        #expect(submitters[0].name == "John Doe")
        #expect(submitters[0].role == "Neighbor")
        #expect(submitters[0].status == .sent)
        #expect(submitters[1].id == 2_548_388)
        #expect(submitters[1].email == "lovely@example.com")
        #expect(submitters[1].name == "Liem")
        #expect(submitters[1].role == "Other Relatives")
        #expect(submitters[1].status == .awaiting)

        // Validate template reference
        #expect(webhook.data.template?.id == 1_037_778)
        #expect(webhook.data.template?.name == "Abstract-2025-05-12-220647")
        #expect(webhook.data.template?.externalId == "0196c746-1042-793f-a529-54ddd1db8817")
        #expect(webhook.data.template?.folderName == "ACH Health/Abstract")

        // Validate created by user
        #expect(webhook.data.createdByUser?.id == 64936)
        #expect(webhook.data.createdByUser?.email == "dos@lemur.com")
    }

    @Test("Submission Archived")
    func submissionArchived() throws {
        let json = """
            {
              "event_type": "submission.archived",
              "timestamp": "2025-05-13T02:15:20.066Z",
              "data": {
                "id": 1920701,
                "archived_at": "2025-05-13T02:15:20.061Z"
              }
            }
            """
        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealSubmissionWebhookEvent.self, from: data)

        // Validate webhook event structure
        #expect(webhook.eventType == .submissionArchived)
        #expect(webhook.data.id == 1_920_701)

        // Validate archived date is present
        #expect(webhook.data.archivedAt != nil)

        // Validate minimal data structure for archived submission
        #expect(webhook.data.createdAt == nil)
        #expect(webhook.data.updatedAt == nil)
        #expect(webhook.data.source == nil)
        #expect(webhook.data.submitters == nil)
        #expect(webhook.data.template == nil)
    }

    @Test("Form viewed")
    func formViewed() throws {
        let json = """
            {
              "event_type": "form.viewed",
              "timestamp": "2025-05-13T02:12:06.267Z",
              "data": {
                "id": 2548387,
                "submission_id": 1920701,
                "email": "docuseal@test.io",
                "phone": null,
                "name": "",
                "ua": null,
                "ip": null,
                "sent_at": "2025-05-13T02:11:37.489Z",
                "opened_at": "2025-05-13T02:12:06.255Z",
                "completed_at": null,
                "declined_at": null,
                "created_at": "2025-05-13T02:11:37.494Z",
                "updated_at": "2025-05-13T02:12:06.256Z",
                "external_id": null,
                "metadata": {},
                "status": "opened",
                "application_key": null,
                "decline_reason": null,
                "role": "Neighbor",
                "preferences": {
                  "send_email": true,
                  "send_sms": false
                },
                "values": [],
                "documents": [],
                "audit_log_url": null,
                "submission_url": "https://docuseal.com/e/naCiW4G3aR8hB5",
                "template": {
                  "id": 1037778,
                  "name": "Abstract-2025-05-12-220647",
                  "external_id": "0196c746-1042-793f-a529-54ddd1db8817",
                  "created_at": "2025-05-13T02:06:48.087Z",
                  "updated_at": "2025-05-13T02:11:22.974Z",
                  "folder_name": "ACH Health/Abstract"
                },
                "submission": {
                  "id": 1920701,
                  "audit_log_url": null,
                  "combined_document_url": null,
                  "created_at": "2025-05-13T02:11:37.491Z",
                  "status": "pending",
                  "url": "https://docuseal.com/e/n87CiW4G3aR8hB5"
                }
              }
            }
            """

        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealFormWebhookEvent.self, from: data)

        // Validate webhook event structure
        #expect(webhook.eventType == .formViewed)
        #expect(webhook.data.id == 2_548_387)
        #expect(webhook.data.submissionId == 1_920_701)
        #expect(webhook.data.email == "docuseal@test.io")
        #expect(webhook.data.name == "")
        #expect(webhook.data.role == "Neighbor")
        #expect(webhook.data.status == .opened)

        // Validate timestamps
        #expect(webhook.data.sentAt != nil)
        #expect(webhook.data.openedAt != nil)
        #expect(webhook.data.completedAt == nil)

        // Validate submission reference
        #expect(webhook.data.submission?.id == 1_920_701)
        #expect(webhook.data.submission?.status == .pending)
        #expect(webhook.data.submission?.url == "https://docuseal.com/e/n87CiW4G3aR8hB5")

        // Validate template reference
        #expect(webhook.data.template?.id == 1_037_778)
        #expect(webhook.data.template?.name == "Abstract-2025-05-12-220647")
        #expect(webhook.data.template?.folderName == "ACH Health/Abstract")

        // Validate empty arrays for viewed event
        #expect(webhook.data.values?.count == 0)
        #expect(webhook.data.documents?.count == 0)
    }

    @Test("Form started")
    func formStarted() throws {
        let json = """
            {
              "event_type": "form.started",
              "timestamp": "2025-05-13T02:12:27.343Z",
              "data": {
                "id": 2548387,
                "submission_id": 1920701,
                "email": "docuseal@test.io",
                "phone": null,
                "name": "",
                "ua": null,
                "ip": null,
                "sent_at": "2025-05-13T02:11:37.489Z",
                "opened_at": "2025-05-13T02:12:06.255Z",
                "completed_at": null,
                "declined_at": null,
                "created_at": "2025-05-13T02:11:37.494Z",
                "updated_at": "2025-05-13T02:12:27.294Z",
                "external_id": null,
                "metadata": {},
                "status": "opened",
                "application_key": null,
                "decline_reason": null,
                "role": "Neighbor",
                "preferences": {
                  "send_email": true,
                  "send_sms": false
                },
                "values": [],
                "documents": [],
                "audit_log_url": null,
                "submission_url": "https://docuseal.com/e/htCiW4G3aR8hB5",
                "template": {
                  "id": 1037778,
                  "name": "Abstract-2025-05-12-220647",
                  "external_id": "0196c746-1042-793f-a529-70ddd1db8817",
                  "created_at": "2025-05-13T02:06:48.087Z",
                  "updated_at": "2025-05-13T02:11:22.974Z",
                  "folder_name": "ACH Health/Abstract"
                },
                "submission": {
                  "id": 1920701,
                  "audit_log_url": null,
                  "combined_document_url": null,
                  "created_at": "2025-05-13T02:11:37.491Z",
                  "status": "pending",
                  "url": "https://docuseal.com/e/HtCiW4G3aR8hB5"
                }
              }
            }
            """

        let data = json.data(using: .utf8)!
        let webhook = try JSONDecoder.docuSealDecoder.decode(DocuSealFormWebhookEvent.self, from: data)

        // Validate webhook event structure
        #expect(webhook.eventType == .formStarted)
        #expect(webhook.data.id == 2_548_387)
        #expect(webhook.data.submissionId == 1_920_701)
        #expect(webhook.data.email == "docuseal@test.io")
        #expect(webhook.data.name == "")
        #expect(webhook.data.role == "Neighbor")
        #expect(webhook.data.status == .opened)

        // Validate progression of timestamps
        #expect(webhook.data.sentAt != nil)
        #expect(webhook.data.openedAt != nil)
        #expect(webhook.data.completedAt == nil)

        // Validate submission reference
        #expect(webhook.data.submission?.id == 1_920_701)
        #expect(webhook.data.submission?.status == .pending)

        // Validate template reference with updated timestamp
        #expect(webhook.data.template?.id == 1_037_778)
        #expect(webhook.data.template?.name == "Abstract-2025-05-12-220647")
        #expect(webhook.data.template?.externalId == "0196c746-1042-793f-a529-70ddd1db8817")

        // Validate preferences
        #expect(webhook.data.preferences?.sendEmail == true)
        #expect(webhook.data.preferences?.sendSms == false)

        // Validate metadata and values are empty
        #expect(webhook.data.metadata?.isEmpty == true)
        #expect(webhook.data.values?.isEmpty == true)
    }
}

// MARK: - Webhook Verification Tests

@Suite("Webhook Verification Tests")
struct WebhookVerificationTests {

    @Test("Webhook secret verification succeeds with correct credentials")
    func testWebhookSecretVerificationSuccess() throws {
        // Should not throw any error
        try DocusealWebhookHandler.verifyWebhookSecret(
            receivedKey: "X-DocuSeal-Secret-Key",
            receivedValue: "my-secret-value",
            expectedKey: "X-DocuSeal-Secret-Key",
            expectedValue: "my-secret-value"
        )
    }

    @Test("Webhook secret verification fails with wrong key")
    func testWebhookSecretVerificationFailsWrongKey() throws {
        #expect {
            try DocusealWebhookHandler.verifyWebhookSecret(
                receivedKey: "Wrong-Key",
                receivedValue: "my-secret-value",
                expectedKey: "X-DocuSeal-Secret-Key",
                expectedValue: "my-secret-value"
            )
        } throws: { error in
            if let docuSealError = error as? DocuSealError,
                case .webhookAuthenticationError(_) = docuSealError
            {
                return true
            }
            return false
        }
    }

    @Test("Webhook secret verification fails with wrong value")
    func testWebhookSecretVerificationFailsWrongValue() throws {
        #expect {
            try DocusealWebhookHandler.verifyWebhookSecret(
                receivedKey: "X-DocuSeal-Secret-Key",
                receivedValue: "wrong-value",
                expectedKey: "X-DocuSeal-Secret-Key",
                expectedValue: "my-secret-value"
            )
        } throws: { error in
            if let docuSealError = error as? DocuSealError,
                case .webhookAuthenticationError(_) = docuSealError
            {
                return true
            }
            return false
        }
    }

    @Test("Webhook secret verification fails with empty credentials")
    func testWebhookSecretVerificationFailsEmpty() throws {
        #expect {
            try DocusealWebhookHandler.verifyWebhookSecret(
                receivedKey: "",
                receivedValue: "",
                expectedKey: "X-DocuSeal-Secret-Key",
                expectedValue: "my-secret-value"
            )
        } throws: { error in
            if let docuSealError = error as? DocuSealError,
                case .webhookAuthenticationError(_) = docuSealError
            {
                return true
            }
            return false
        }
    }

}
