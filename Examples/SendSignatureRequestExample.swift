//
//  SendSignatureRequestExample.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import DocuSealKit
import Logging

@main
struct SendSignatureRequestExample {
    static func main() async throws {
        // Create a logger
        var logger = Logger(label: "com.example.docuseal")
        logger.logLevel = .info

        // Initialize the client with your API key
        let apiKey = ProcessInfo.processInfo.environment["DOCUSEAL_API_KEY"] ?? "YOUR_API_KEY"
        let client = DocuSealClient(apiKey: apiKey, logger: logger)

        do {
            // 1. First create a template from HTML
            logger.info("Creating template from HTML")
            let templateRequest = CreateTemplateFromHtmlRequest(
                html: """
                  <h1>Consulting Agreement</h1>
                  <p>This Consulting Agreement ("Agreement") is entered into as of <text-field name="Date" role="Client" type="date"></text-field>, by and between:</p>

                  <p><b>Company:</b> <text-field name="Company Name" role="Company" required="true"></text-field>, with its principal place of business at <text-field name="Company Address" role="Company"></text-field></p>

                  <p><b>Consultant:</b> <text-field name="Consultant Name" role="Consultant" required="true"></text-field>, with address at <text-field name="Consultant Address" role="Consultant"></text-field></p>

                  <h2>Services</h2>
                  <p>Consultant shall provide the following services to Company:</p>
                  <p><text-field name="Services Description" role="Company" required="true"></text-field></p>

                  <h2>Payment</h2>
                  <p>Company agrees to pay Consultant $<text-field name="Hourly Rate" role="Company" type="number"></text-field> per hour for services rendered.</p>

                  <h2>Term</h2>
                  <p>This Agreement shall commence on <text-field name="Start Date" role="Company" type="date"></text-field> and continue until <text-field name="End Date" role="Company" type="date"></text-field>, unless terminated earlier.</p>

                  <h2>Signatures</h2>
                  <p>The parties hereto have executed this Agreement as of the date first written above.</p>

                  <div style="display: flex; justify-content: space-between; margin-top: 50px;">
                      <div>
                          <p><b>Company:</b></p>
                          <signature-field name="Company Signature" role="Company" required="true"></signature-field>
                          <p><text-field name="Company Signatory Name" role="Company" required="true"></text-field></p>
                          <p>Title: <text-field name="Company Signatory Title" role="Company"></text-field></p>
                      </div>
                      <div>
                          <p><b>Consultant:</b></p>
                          <signature-field name="Consultant Signature" role="Consultant" required="true"></signature-field>
                          <p><text-field name="Consultant Signatory Name" role="Consultant" required="true"></text-field></p>
                      </div>
                  </div>
                  """,
                name: "Consulting Agreement Template"
            )

            let template = try await client.createTemplateFromHtml(request: templateRequest)
            logger.info("Template created with ID: \(template.id)")

            // 2. Create a submission (signature request) for the template
            logger.info("Creating submission with pre-filled Company values")
            let submissionRequest = CreateSubmissionRequest(
                templateId: template.id,
                submitters: [
                    SubmissionSubmitter(
                        role: "Company",
                        email: "company@example.com",
                        values: [
                          "Company Name": "Acme Corporation" as AnyCodable,
                          "Company Address": "123 Business St, Business City, 12345" as AnyCodable,
                          "Services Description": "Software development and consulting services" as AnyCodable,
                          "Hourly Rate": 150 as AnyCodable,
                          "Start Date": "2024-06-01" as AnyCodable,
                          "End Date": "2024-12-31" as AnyCodable,
                          "Company Signatory Name": "Jane Smith" as AnyCodable,
                          "Company Signatory Title": "CEO" as AnyCodable,
                        ]
                    ),
                    SubmissionSubmitter(
                        role: "Consultant",
                        email: "consultant@example.com"
                    ),
                ]
            )

            let submitters = try await client.createSubmission(request: submissionRequest)
            logger.info("Submission created with \(submitters.count) submitters")

            for submitter in submitters {
                logger.info(
                  "Submitter: \(submitter.email), Role: \(submitter.role), Status: \(submitter.status)")
                if let embedSrc = submitter.embedSrc {
                  logger.info("Signing URL for \(submitter.role): \(embedSrc)")
                }
            }

            logger.info("\nSignature requests have been sent successfully!")
            logger.info("The Company and Consultant will receive emails with links to sign the document.")

        } catch let error as DocusealError {
            switch error {
            case .httpError(let statusCode, let message):
                logger.error("HTTP Error: \(statusCode) - \(message)")
            case .decodingError(let error):
                logger.error("Decoding Error: \(error)")
            case .encodingError(let error):
                logger.error("Encoding Error: \(error)")
            case .invalidURL:
                logger.error("Invalid URL")
            }
        } catch {
            logger.error("Unexpected error: \(error)")
        }
    }
}
