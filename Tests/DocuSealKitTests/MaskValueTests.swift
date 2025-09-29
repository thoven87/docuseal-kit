//
//  MaskValueTests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 8/3/25.
//

import Foundation
import Testing

@testable import DocuSealKit

@Suite("Mask Value Type Support")
struct MaskValueTests {

    @Test("Mask supports boolean values")
    func testBooleanMask() async throws {
        let mask = MaskValue.mask(true)

        switch mask {
        case .bool(let value):
            #expect(value == true)
        case .number(_):
            Issue.record("Expected boolean mask, got number")
        }
    }

    @Test("Mask supports number values")
    func testNumberMask() async throws {
        let mask = MaskValue.mask(4)

        switch mask {
        case .bool(_):
            Issue.record("Expected number mask, got boolean")
        case .number(let value):
            #expect(value == 4)
        }
    }

    @Test("Field preferences accept mask values")
    func testFieldPreferencesWithMask() async throws {
        let preferences = FieldPreferences(
            fontSize: 12,
            fontType: .bold,
            font: .helvetica,
            color: .black,
            align: .center,
            valign: .center,
            format: "masked",
            price: nil,
            currency: nil,
            mask: .mask(true)
        )

        #expect(preferences.fontSize == 12)
        #expect(preferences.fontType == .bold)

        if case .bool(let maskValue) = preferences.mask {
            #expect(maskValue == true)
        } else {
            Issue.record("Expected boolean mask value")
        }
    }
}
