//
//  BooleanFieldTests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 7/3/25.
//

import Foundation
import Testing

@testable import DocuSealKit

@Suite("Boolean Field Value Handling")
struct BooleanFieldTests {

    @Test("Boolean values support true/false strings")
    func testBooleanTrueFalseValues() async throws {
        let field = SubmissionField(
            name: "accepts_terms",
            defaultValue: ["boolean": "true"],
            required: true,
            title: "Accept Terms"
        )

        #expect(field.name == "accepts_terms")
        #expect(field.defaultValue["boolean"] == "true")
        #expect(field.required == true)
    }

    @Test("Boolean values support 1/0 numeric strings")
    func testBooleanNumericValues() async throws {
        let field = SubmissionField(
            name: "newsletter_signup",
            defaultValue: ["number": "1"],
            required: false,
            title: "Newsletter Signup"
        )

        #expect(field.name == "newsletter_signup")
        #expect(field.defaultValue["number"] == "1")
        #expect(field.required == false)
    }

    @Test("Field values support mixed boolean types")
    func testMixedBooleanFieldValues() async throws {
        let values = [
            FieldValue(field: "agrees_terms", stringValue: "true"),
            FieldValue(field: "newsletter_signup", stringValue: "1"),
            FieldValue(field: "privacy_consent", stringValue: "false"),
            FieldValue(field: "sms_notifications", stringValue: "0"),
        ]

        #expect(values.count == 4)
        #expect(values[0].value?.stringValue == "true")
        #expect(values[1].value?.stringValue == "1")
        #expect(values[2].value?.stringValue == "false")
        #expect(values[3].value?.stringValue == "0")
    }

    @Test("Boolean validation patterns accept multiple formats")
    func testBooleanValidationPatterns() async throws {
        let validation = FieldValidation(
            pattern: "^(true|false|1|0|yes|no)$",
            message: "Must be true/false, 1/0, or yes/no"
        )

        #expect(validation.pattern == "^(true|false|1|0|yes|no)$")
        #expect(validation.message == "Must be true/false, 1/0, or yes/no")
    }
}
