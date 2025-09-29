//
//  SigningOrderTests.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation
import Testing

@testable import DocuSealKit

@Suite("Signing Order and Groups")
struct SigningOrderTests {

    @Test("Sequential signing order preserved")
    func testSequentialSigningOrder() async throws {
        let submitters = [
            SubmissionSubmitter(
                name: "CEO",
                email: "ceo@company.com",
                order: 0
            ),
            SubmissionSubmitter(
                name: "CFO",
                email: "cfo@company.com",
                order: 1
            ),
            SubmissionSubmitter(
                name: "Legal",
                email: "legal@company.com",
                order: 2
            ),
        ]

        #expect(submitters[0].order == 0)
        #expect(submitters[1].order == 1)
        #expect(submitters[2].order == 2)
        #expect(submitters[0].name == "CEO")
    }

    @Test("Signing groups with same order number")
    func testSigningGroups() async throws {
        let submitters = [
            // Group 1: Both reviewers
            SubmissionSubmitter(
                name: "Reviewer A",
                email: "reviewera@company.com",
                order: 0
            ),
            SubmissionSubmitter(
                name: "Reviewer B",
                email: "reviewerb@company.com",
                order: 0  // Same order = same group
            ),
            // Group 2: Approver
            SubmissionSubmitter(
                name: "Approver",
                email: "approver@company.com",
                order: 1
            ),
        ]

        #expect(submitters[0].order == submitters[1].order)
        #expect(submitters[0].order == 0)
        #expect(submitters[2].order == 1)
    }

    @Test("Submission order types")
    func testSubmissionOrderTypes() async throws {
        #expect(SubmittersOrder.preserved.rawValue == "preserved")
        #expect(SubmittersOrder.random.rawValue == "random")
    }

    @Test("Phone 2FA security feature")
    func testPhone2FASupport() async throws {
        let submitter = SubmissionSubmitter(
            name: "Secure User",
            email: "secure@company.com",
            requirePhone2FA: true
        )

        #expect(submitter.requirePhone2FA == true)
        #expect(submitter.name == "Secure User")
    }
}
