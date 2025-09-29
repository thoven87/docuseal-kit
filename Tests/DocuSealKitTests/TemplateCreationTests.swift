//
//  TemplateCreationTests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 8/5/25.
//

import Foundation
import Testing

@testable import DocuSealKit

// MARK: - Template Creation Feature Tests

@Suite("Template Creation Features")
struct TemplateCreationTests {

    @Test("PDF template with all parameters")
    func testPDFTemplateCreation() async throws {
        let request = CreateTemplateFromPdfRequest(
            name: "Test Template",
            folderName: "Testing/Templates",
            externalId: "test-001",
            sharedLink: true,
            documents: [],
            flatten: false,
            removeTags: true
        )

        #expect(request.name == "Test Template")
        #expect(request.folderName == "Testing/Templates")
        #expect(request.externalId == "test-001")
        #expect(request.sharedLink == true)
        #expect(request.flatten == false)
        #expect(request.removeTags == true)
    }

    @Test("HTML template with shared link")
    func testHTMLTemplateCreation() async throws {
        let request = CreateTemplateFromHtmlRequest(
            html: "<p>Test HTML</p>",
            name: "HTML Template",
            size: .a4,
            externalId: "html-001",
            folderName: "HTML/Templates",
            sharedLink: false,
            documents: nil
        )

        #expect(request.html == "<p>Test HTML</p>")
        #expect(request.name == "HTML Template")
        #expect(request.size == .a4)
        #expect(request.sharedLink == false)
    }

    @Test("DOCX template with folder support")
    func testDOCXTemplateCreation() async throws {
        let request = CreateTemplateFromDocxRequest(
            name: "DOCX Template",
            externalId: "docx-001",
            folderName: "Word/Templates",
            sharedLink: true,
            documents: []
        )

        #expect(request.name == "DOCX Template")
        #expect(request.folderName == "Word/Templates")
        #expect(request.sharedLink == true)
    }
}
