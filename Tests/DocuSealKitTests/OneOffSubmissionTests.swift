//
//  OneOffSubmissionTests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 8/3/25.
//

import Foundation
import Testing

@testable import DocuSealKit

// MARK: - One-off Submission Tests

@Suite("One-off Submissions")
struct OneOffSubmissionTests {

    @Test("PDF submission with merge documents")
    func testPDFSubmissionCreation() async throws {
        let request = CreateSubmissionFromPdfRequest(
            pdf: "base64-pdf-content",
            name: "Test PDF",
            submitters: [],
            folderName: "Submissions/PDF",
            mergeDocuments: true,
            removeTags: false
        )

        #expect(request.pdf == "base64-pdf-content")
        #expect(request.name == "Test PDF")
        #expect(request.folderName == "Submissions/PDF")
        #expect(request.mergeDocuments == true)
        #expect(request.removeTags == false)
    }

    @Test("HTML submission with merge support")
    func testHTMLSubmissionCreation() async throws {
        let request = CreateSubmissionFromHtmlRequest(
            html: "<p>Test content</p>",
            name: "HTML Submission",
            submitters: [],
            folderName: "Submissions/HTML",
            mergeDocuments: false
        )

        #expect(request.html == "<p>Test content</p>")
        #expect(request.mergeDocuments == false)
    }

    @Test("DOCX submission with all parameters")
    func testDOCXSubmissionCreation() async throws {
        let request = CreateSubmissionFromDocxRequest(
            docx: "base64-docx-content",
            name: "DOCX Submission",
            submitters: [],
            externalId: "docx-sub-001",
            folderName: "Submissions/DOCX",
            mergeDocuments: true,
            removeTags: true
        )

        #expect(request.docx == "base64-docx-content")
        #expect(request.externalId == "docx-sub-001")
        #expect(request.mergeDocuments == true)
        #expect(request.removeTags == true)
    }
}
