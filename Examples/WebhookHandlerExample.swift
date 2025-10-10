//
//  WebhookHandlerExample.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import DocuSealKit
import Foundation
import Logging

/// Example of a webhook handler for a server backend
struct DocuSealWebhookController {
    private let logger: Logger

    init(logger: Logger = Logger(label: "com.example.docuseal.webhooks")) {
        self.logger = logger
    }

    /// Handle a webhook request
    /// - Parameter requestBody: The raw request body data
    /// - Returns: A boolean indicating if the webhook was processed successfully
    func handleWebhook(requestBody: ByteBuffer) async -> Bool {
        do {
            // Parse the webhook event
            let (eventType, payload) = try DocusealWebhookHandler.parseWebhookEvent(from: requestBody)
            logger.info("Received webhook event: \(eventType)")

            // Process based on event type
            switch eventType {
            case .formViewed:
                let event = try DocuSealWebhookHandler.processFormEvent(data: payload)
                logger.info(
                    "Form viewed: Submitter \(event.data.id) (\(event.data.email ?? "unknown")) viewed the form"
                )
                // Track analytics about form views
                return true

            case .formStarted:
                let event = try DocuSealWebhookHandler.processFormEvent(data: payload)
                logger.info("Form started: Submitter \(event.data.id) started filling out the form")
                // Maybe send notification to sales team
                return true

            case .formCompleted:
                let event = try DocuSealWebhookHandler.processFormEvent(data: payload)
                logger.info("Form completed: Submitter \(event.data.id) completed the form")

                // Process the completed form data
                if let values = event.data.values {
                    logger.info("Form values:")
                    for value in values {
                        logger.info("  \(value.field): \(value.value)")
                    }
                }

                // Download signed documents
                if let documents = event.data.documents, let auditLogUrl = event.data.auditLogUrl {
                    logger.info("Signed documents are available:")
                    logger.info("  Audit log: \(auditLogUrl)")

                    for document in documents {
                        logger.info("  Document: \(document.name) - \(document.url)")
                        // await downloadAndStoreDocument(from: document.url, name: document.name)
                    }

                    // Trigger some business process based on the completed form
                    // await triggerOnboardingProcess(for: event.data)
                }

                return true

            case .formDeclined:
                let event = try DocuSealWebhookHandler.processFormEvent(data: payload)
                logger.info("Form declined: Submitter \(event.data.id) declined to sign")
                if let reason = event.data.declineReason {
                    logger.info("Decline reason: \(reason)")
                }
                // Notify the appropriate team
                return true

            case .submissionCreated:
                let event = try DocuSealWebhookHandler.processSubmissionEvent(data: payload)
                logger.info("Submission created: ID \(event.data.id)")
                // Track new submission in your system
                return true

            case .submissionCompleted:
                let event = try DocuSealWebhookHandler.processSubmissionEvent(data: payload)
                logger.info("Submission completed: ID \(event.data.id)")
                logger.info("All parties have signed the document")

                // Download the final documents with all signatures
                if let documents = event.data.documents, let auditLogUrl = event.data.auditLogUrl {
                    logger.info("Completed documents are available:")
                    logger.info("  Audit log: \(auditLogUrl)")

                    for document in documents {
                        logger.info("  Document: \(document.name) - \(document.url)")
                        // await downloadAndArchiveFinalDocument(from: document.url, name: document.name)
                    }

                    // Mark the process as completed in your system
                    // await completeBusinessProcess(for: event.data.id)
                }

                return true

            case .submissionExpired, .submissionArchived:
                let event = try DocuSealWebhookHandler.processSubmissionEvent(data: payload)
                logger.info("Submission \(eventType): ID \(event.data.id)")
                // Update status in your system
                return true

            case .templateCreated, .templateUpdated:
                let event = try DocuSealWebhookHandler.processTemplateEvent(data: payload)
                logger.info("Template \(eventType): ID \(event.data.id), Name: \(event.data.name)")
                // Maybe update cached template list
                return true
            }

        } catch {
            logger.error("Failed to process webhook: \(error)")
            return false
        }
    }

    // Example method to download and store a document
    private func downloadAndStoreDocument(from url: String, name: String) async {
        // Implementation would depend on your storage system
        logger.info("Downloading document: \(name) from \(url)")
    }

    // Example method to trigger a business process
    private func triggerOnboardingProcess(for formData: FormWebhookData) async {
        logger.info("Triggering onboarding process for submitter: \(formData.id)")
        // Implementation would connect to your business systems
    }

    // Example method to complete a business process
    private func completeBusinessProcess(for submissionId: Int) async {
        logger.info("Completing business process for submission: \(submissionId)")
        // Implementation would update your business systems
    }
}
