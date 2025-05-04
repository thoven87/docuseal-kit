//
//  DocuSealExample.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import DocusealKit
import Logging

@main
struct DocuSealExample {
    static func main() async {
        // Replace with your API key
        let apiKey = "YOUR_API_KEY_HERE"

        // Initialize the client - uses HTTPClient.shared
        let client = DocuSealClient(apiKey: apiKey)

        do {
            // List templates
            logger.info("\nListing templates...")
            let templates = try await client.listTemplates()
            logger.info("Found \(templates.data.count) templates")

            // If templates exist, get the first one
            if let firstTemplate = templates.data.first {
                logger.info("\nTemplate details:")
                logger.info("ID: \(firstTemplate.id)")
                logger.info("Name: \(firstTemplate.name)")
                logger.info("Created at: \(firstTemplate.createdAt)")

                // Create a submission for this template
                logger.info("\nCreating submission...")
                let submissionRequest = CreateSubmissionRequest(
                    templateId: firstTemplate.id,
                    submitters: [
                        SubmissionSubmitter(
                            role: firstTemplate.submitters.first?.name ?? "Submitter",
                            email: "example@test.com"
                        )
                    ]
                )

                let submitters = try await client.createSubmission(request: submissionRequest)
                logger.info("Created submission with \(submitters.count) submitters")

                if let firstSubmitter = submitters.first {
                    logger.info("\nSubmitter details:")
                    logger.info("ID: \(firstSubmitter.id)")
                    logger.info("Email: \(firstSubmitter.email)")
                    logger.info("Status: \(firstSubmitter.status)")
                    if let slug = firstSubmitter.embedSrc {
                        logger.info("Signing URL: \(slug)")
                    }
                } else {
                    logger.info("No templates found. Create a template first.")
                }
            }

        } catch let error as DocuSealError {
            switch error {
            case .httpError(let statusCode, let message):
                logger.info("HTTP Error: \(statusCode) - \(message)")
            case .decodingError(let error):
                logger.info("Decoding Error: \(error)")
            case .encodingError(let error):
                logger.info("Encoding Error: \(error)")
            case .invalidURL(let error):
                logger.info("Invalid URL: \(error)")
            }
        } catch {
            logger.info("Error: \(error)")
        }
    }
}
