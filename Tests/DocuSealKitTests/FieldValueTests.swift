//
//  FieldValueTests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 1/3/25.
//

import Foundation
import Testing

@testable import DocuSealKit

// MARK: - FieldValue Decoding Tests

@Suite("FieldValue Model Tests")
struct FieldValueTests {

    // MARK: - JSON Decoding Tests

    @Test("Decode boolean field value")
    func testDecodeBooleanFieldValue() async throws {
        let json = """
            {
                "field": "Check Box2",
                "value": false
            }
            """

        let data = json.data(using: .utf8)!
        let fieldValue = try JSONDecoder().decode(FieldValue.self, from: data)

        #expect(fieldValue.field == "Check Box2")
        #expect(fieldValue.value?.boolValue == false)
        #expect(fieldValue.value?.stringValue == nil)
    }

    @Test("Decode null field value")
    func testDecodeNullFieldValue() async throws {
        let json = """
            {
                "field": "Text11",
                "value": null
            }
            """

        let data = json.data(using: .utf8)!
        let fieldValue = try JSONDecoder().decode(FieldValue.self, from: data)

        #expect(fieldValue.field == "Text11")
        #expect(fieldValue.value == nil)
    }

    @Test("Decode string field value")
    func testDecodeStringFieldValue() async throws {
        let json = """
            {
                "field": "First Name",
                "value": "John Doe"
            }
            """

        let data = json.data(using: .utf8)!
        let fieldValue = try JSONDecoder().decode(FieldValue.self, from: data)

        #expect(fieldValue.field == "First Name")
        #expect(fieldValue.value?.stringValue == "John Doe")
        #expect(fieldValue.value?.boolValue == nil)
    }

    @Test("Decode integer field value")
    func testDecodeIntegerFieldValue() async throws {
        let json = """
            {
                "field": "Age",
                "value": 25
            }
            """

        let data = json.data(using: .utf8)!
        let fieldValue = try JSONDecoder().decode(FieldValue.self, from: data)

        #expect(fieldValue.field == "Age")
        #expect(fieldValue.value?.intValue == 25)
        #expect(fieldValue.value?.stringValue == nil)
    }

    @Test("Decode double field value")
    func testDecodeDoubleFieldValue() async throws {
        let json = """
            {
                "field": "Salary",
                "value": 50000.50
            }
            """

        let data = json.data(using: .utf8)!
        let fieldValue = try JSONDecoder().decode(FieldValue.self, from: data)

        #expect(fieldValue.field == "Salary")
        #expect(fieldValue.value?.doubleValue == 50000.50)
        #expect(fieldValue.value?.intValue == nil)
    }

    @Test("Decode array of mixed field values")
    func testDecodeMixedFieldValuesArray() async throws {
        let json = """
            [
                {
                    "field": "Check Box2",
                    "value": false
                },
                {
                    "field": "Check Box3",
                    "value": true
                },
                {
                    "field": "Text11",
                    "value": null
                },
                {
                    "field": "First Name",
                    "value": "Jane Smith"
                },
                {
                    "field": "Age",
                    "value": 30
                },
                {
                    "field": "Rating",
                    "value": 4.5
                }
            ]
            """

        let data = json.data(using: .utf8)!
        let fieldValues = try JSONDecoder().decode([FieldValue].self, from: data)

        #expect(fieldValues.count == 6)

        // Test boolean false
        #expect(fieldValues[0].field == "Check Box2")
        #expect(fieldValues[0].value?.boolValue == false)

        // Test boolean true
        #expect(fieldValues[1].field == "Check Box3")
        #expect(fieldValues[1].value?.boolValue == true)

        // Test null value
        #expect(fieldValues[2].field == "Text11")
        #expect(fieldValues[2].value == nil)

        // Test string value
        #expect(fieldValues[3].field == "First Name")
        #expect(fieldValues[3].value?.stringValue == "Jane Smith")

        // Test integer value
        #expect(fieldValues[4].field == "Age")
        #expect(fieldValues[4].value?.intValue == 30)

        // Test double value
        #expect(fieldValues[5].field == "Rating")
        #expect(fieldValues[5].value?.doubleValue == 4.5)
    }

    // MARK: - JSON Encoding Tests

    @Test("Encode boolean field value")
    func testEncodeBooleanFieldValue() async throws {
        let fieldValue = FieldValue(field: "Check Box", boolValue: true)

        let data = try JSONEncoder().encode(fieldValue)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"field\":\"Check Box\""))
        #expect(json.contains("\"value\":true"))
    }

    @Test("Encode null field value")
    func testEncodeNullFieldValue() async throws {
        let fieldValue = FieldValue(field: "Empty Field")

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let data = try encoder.encode(fieldValue)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"field\" : \"Empty Field\""))
        #expect(fieldValue.value == nil)
    }

    @Test("Encode string field value")
    func testEncodeStringFieldValue() async throws {
        let fieldValue = FieldValue(field: "Name", stringValue: "Test User")

        let data = try JSONEncoder().encode(fieldValue)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"field\":\"Name\""))
        #expect(json.contains("\"value\":\"Test User\""))
    }

    @Test("Encode integer field value")
    func testEncodeIntegerFieldValue() async throws {
        let fieldValue = FieldValue(field: "Count", intValue: 42)

        let data = try JSONEncoder().encode(fieldValue)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"field\":\"Count\""))
        #expect(json.contains("\"value\":42"))
    }

    @Test("Encode double field value")
    func testEncodeDoubleFieldValue() async throws {
        let fieldValue = FieldValue(field: "Price", doubleValue: 99.99)

        let data = try JSONEncoder().encode(fieldValue)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"field\":\"Price\""))
        #expect(json.contains("\"value\":99.99"))
    }

    // MARK: - Convenience Property Tests

    @Test("Test FieldValueType description property")
    func testFieldValueTypeDescription() async throws {
        let stringValue = FieldValueType.string("Hello World")
        let boolValue = FieldValueType.bool(true)
        let intValue = FieldValueType.int(123)
        let doubleValue = FieldValueType.double(45.67)

        #expect(stringValue.description == "Hello World")
        #expect(boolValue.description == "true")
        #expect(intValue.description == "123")
        #expect(doubleValue.description == "45.67")
    }

    @Test("Test convenience property access")
    func testConveniencePropertyAccess() async throws {
        let fieldValue = FieldValue(field: "Test", stringValue: "Sample Text")

        #expect(fieldValue.value?.stringValue == "Sample Text")
        #expect(fieldValue.value?.boolValue == nil)
        #expect(fieldValue.value?.intValue == nil)
        #expect(fieldValue.value?.doubleValue == nil)
    }

    // MARK: - Initialization Tests

    @Test("Test all convenience initializers")
    func testConvenienceInitializers() async throws {
        let stringField = FieldValue(field: "text", stringValue: "test")
        let boolField = FieldValue(field: "checkbox", boolValue: false)
        let intField = FieldValue(field: "number", intValue: 100)
        let doubleField = FieldValue(field: "decimal", doubleValue: 3.14)
        let nullField = FieldValue(field: "empty")

        #expect(stringField.value?.stringValue == "test")
        #expect(boolField.value?.boolValue == false)
        #expect(intField.value?.intValue == 100)
        #expect(doubleField.value?.doubleValue == 3.14)
        #expect(nullField.value == nil)
    }

    // MARK: - Round-trip Tests

    @Test("Test encode-decode round trip for all types")
    func testEncodeDecodeRoundTrip() async throws {
        let originalValues = [
            FieldValue(field: "string_field", stringValue: "Hello"),
            FieldValue(field: "bool_field", boolValue: true),
            FieldValue(field: "int_field", intValue: 42),
            FieldValue(field: "double_field", doubleValue: 3.14159),
            FieldValue(field: "null_field"),
        ]

        // Encode
        let data = try JSONEncoder().encode(originalValues)

        // Decode
        let decodedValues = try JSONDecoder().decode([FieldValue].self, from: data)

        // Verify
        #expect(decodedValues.count == originalValues.count)

        #expect(decodedValues[0].field == "string_field")
        #expect(decodedValues[0].value?.stringValue == "Hello")

        #expect(decodedValues[1].field == "bool_field")
        #expect(decodedValues[1].value?.boolValue == true)

        #expect(decodedValues[2].field == "int_field")
        #expect(decodedValues[2].value?.intValue == 42)

        #expect(decodedValues[3].field == "double_field")
        #expect(decodedValues[3].value?.doubleValue == 3.14159)

        #expect(decodedValues[4].field == "null_field")
        #expect(decodedValues[4].value == nil)
    }
}
