//
//  APITests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 6/10/25.
//

import Foundation
import Testing

@testable import DocuSealKit

// MARK: - Advanced Field Validation Tests

@Suite("Advanced Field Validation")
struct FieldValidationTests {

    @Test("Field validation with pattern and ranges")
    func testCompleteFieldValidation() async throws {
        let validation = FieldValidation(
            pattern: "^[0-9]{3}-[0-9]{2}-[0-9]{4}$",
            message: "SSN format: XXX-XX-XXXX",
            min: "000-00-0001",
            max: "999-99-9999",
            step: nil
        )

        #expect(validation.pattern == "^[0-9]{3}-[0-9]{2}-[0-9]{4}$")
        #expect(validation.message == "SSN format: XXX-XX-XXXX")
        #expect(validation.min == "000-00-0001")
        #expect(validation.max == "999-99-9999")
    }

    @Test("Numeric validation with step")
    func testNumericValidation() async throws {
        let validation = FieldValidation(
            pattern: nil,
            message: "Invalid percentage",
            min: "0",
            max: "100",
            step: 0.01
        )

        #expect(validation.min == "0")
        #expect(validation.max == "100")
        #expect(validation.step == 0.01)
    }

    @Test("Field with validation and preferences")
    func testFieldWithValidationAndPreferences() async throws {
        let field = SubmissionField(
            name: "validated_field",
            defaultValue: ["text": "test"],
            required: true,
            title: "Validated Field",
            description: "Field with validation",
            validation: FieldValidation(
                pattern: "^[a-zA-Z]+$",
                message: "Letters only"
            ),
            preferences: FieldPreferences(
                fontSize: 14,
                fontType: .bold,
                font: nil,
                color: nil,
                align: nil,
                valign: nil,
                format: nil,
                price: nil,
                currency: nil,
                mask: .mask(2)
            )
        )

        #expect(field.name == "validated_field")
        #expect(field.validation?.pattern == "^[a-zA-Z]+$")
        #expect(field.preferences?.fontSize == 14)
    }
}

// MARK: - Document Operations Tests

@Suite("Document Operations")
struct DocumentOperationTests {

    @Test("Document update with replace and remove")
    func testDocumentUpdateOperations() async throws {
        let updateRequest = UpdateTemplateDocumentsRequest(
            documents: [
                UpdateTemplateDocumentRequest(
                    name: "Replacement Doc",
                    file: "new-content",
                    position: 0,
                    replace: true,
                    remove: false
                ),
                UpdateTemplateDocumentRequest(
                    name: "Doc to Remove",
                    position: 1,
                    replace: false,
                    remove: true
                ),
            ],
            merge: true
        )

        #expect(updateRequest.documents.count == 2)
        #expect(updateRequest.documents[0].replace == true)
        #expect(updateRequest.documents[1].remove == true)
        #expect(updateRequest.merge == true)
    }

    @Test("Document positions and operations")
    func testDocumentPositions() async throws {
        let doc = UpdateTemplateDocumentRequest(
            name: "Test Doc",
            file: "content",
            html: nil,
            position: 5,
            replace: false,
            remove: false
        )

        #expect(doc.position == 5)
        #expect(doc.replace == false)
        #expect(doc.remove == false)
    }
}

// MARK: - Query Parameter Tests

@Suite("Query Parameter Support")
struct QueryParameterTests {

    @Test("Template query with include parameter")
    func testTemplateQuery() async throws {
        let query = TemplateQuery(include: "fields,submitters,documents")
        let items = query.queryItems

        #expect(items.count == 1)
        #expect(items[0].name == "include")
        #expect(items[0].value == "fields,submitters,documents")
    }

    @Test("Submission query with include parameter")
    func testSubmissionQuery() async throws {
        let query = SubmissionQuery(include: "template,documents")
        let items = query.queryItems

        #expect(items.count == 1)
        #expect(items[0].name == "include")
        #expect(items[0].value == "template,documents")
    }

    @Test("Submitter query with include parameter")
    func testSubmitterQuery() async throws {
        let query = SubmitterQuery(include: "submission,fields")
        let items = query.queryItems

        #expect(items.count == 1)
        #expect(items[0].name == "include")
        #expect(items[0].value == "submission,fields")
    }

    @Test("Empty query parameters")
    func testEmptyQueryParameters() async throws {
        let query = TemplateQuery(include: nil)
        let items = query.queryItems

        #expect(items.count == 0)
    }
}

// MARK: - Edge Case Tests

@Suite("Edge Cases and Boundary Conditions")
struct EdgeCaseTests {

    @Test("Empty field values with validation")
    func testEmptyFieldValues() async throws {
        let field = SubmissionField(
            name: "optional_field",
            defaultValue: [:],
            required: false,
            validation: FieldValidation(
                pattern: "^(|.{3,})$",  // Empty or 3+ chars
                message: "Either empty or 3+ characters"
            )
        )

        #expect(field.defaultValue.isEmpty)
        #expect(field.required == false)
        #expect(field.validation?.pattern?.contains("|") == true)
    }

    @Test("Large mask numbers")
    func testLargeMaskNumbers() async throws {
        let preferences = FieldPreferences(
            fontSize: nil,
            fontType: nil,
            font: nil,
            color: nil,
            align: nil,
            valign: nil,
            format: nil,
            price: nil,
            currency: nil,
            mask: .mask(999)
        )

        if case .number(let value) = preferences.mask {
            #expect(value == 999)
        } else {
            Issue.record("Expected large number mask")
        }
    }

    @Test("Unicode support in fields")
    func testUnicodeSupport() async throws {
        let field = SubmissionField(
            name: "unicode_field_测试",
            defaultValue: ["text": "Value with émojis 🎉"],
            title: "Unicode Field: 测试 🌟",
            description: "Supports international: çñü"
        )

        #expect(field.name.contains("测试"))
        #expect(field.defaultValue["text"]?.contains("🎉") == true)
        #expect(field.title?.contains("🌟") == true)
        #expect(field.description?.contains("çñü") == true)
    }

    @Test("Maximum validation combinations")
    func testComplexValidation() async throws {
        let validation = FieldValidation(
            pattern: "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$",
            message: "8+ chars with upper, lower, digit",
            min: "8",
            max: "100",
            step: 1.0
        )

        #expect(validation.pattern?.contains("(?=.*[A-Z])") == true)
        #expect(validation.min == "8")
        #expect(validation.max == "100")
        #expect(validation.step == 1.0)
    }
}

// MARK: - JSON Encoding/Decoding Tests

@Suite("JSON Serialization")
struct SerializationTests {

    @Test("MaskValue encoding and decoding")
    func testMaskValueSerialization() async throws {
        let boolMask = MaskValue.mask(true)
        let numberMask = MaskValue.mask(5)

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let boolData = try encoder.encode(boolMask)
        let numberData = try encoder.encode(numberMask)

        let decodedBool = try decoder.decode(MaskValue.self, from: boolData)
        let decodedNumber = try decoder.decode(MaskValue.self, from: numberData)

        if case .bool(let value) = decodedBool {
            #expect(value == true)
        }

        if case .number(let value) = decodedNumber {
            #expect(value == 5)
        }
    }

    @Test("Complex field serialization")
    func testComplexFieldSerialization() async throws {
        let field = SubmissionField(
            name: "complex_field",
            defaultValue: ["text": "test", "number": "123"],
            required: true,
            title: "Complex Field",
            validation: FieldValidation(
                pattern: "^test[0-9]+$",
                message: "Must start with 'test' followed by numbers"
            ),
            preferences: FieldPreferences(
                fontSize: 12,
                fontType: .boldItalic,
                font: .courier,
                color: .blue,
                align: .center,
                valign: .bottom,
                format: "custom",
                price: nil,
                currency: nil,
                mask: .mask(false)
            )
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(field)
        let decoded = try decoder.decode(SubmissionField.self, from: data)

        #expect(decoded.name == field.name)
        #expect(decoded.required == field.required)
        #expect(decoded.validation?.pattern == field.validation?.pattern)
    }
}

// MARK: - Helper Extensions for Testing

extension SubmissionSubmitter {
    init(name: String, email: String, order: Int? = nil, requirePhone2FA: Bool? = nil) {
        self.init(
            name: name,
            role: nil,
            email: email,
            phone: nil,
            values: nil,
            externalId: nil,
            completed: nil,
            metadata: nil,
            sendEmail: true,
            sendSms: false,
            replyTo: nil,
            completedRedirectUrl: nil,
            message: nil,
            fields: nil,
            roles: nil,
            order: order,
            requirePhone2FA: requirePhone2FA
        )
    }
}
