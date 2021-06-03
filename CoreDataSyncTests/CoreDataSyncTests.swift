//
//  CoreDataSyncTests.swift
//  CoreDataSyncTests
//

import XCTest
import CloudKit
@testable import CoreDataSync

class CoreDataSyncTests: XCTestCase {

    func test_CloudKitReadiness() throws {
        // Fetch zones from the Private Database of the CKContainer for the current user to test for valid/ready state
        let container = CKContainer(identifier: Config.containerIdentifier)
        let database = container.privateCloudDatabase

        let fetchExpectation = expectation(description: "Expect CloudKit fetch to complete")
        database.fetchAllRecordZones { _, error in
            if let error = error as? CKError {
                switch error.code {
                case .badContainer, .badDatabase:
                    XCTFail("Create or select a CloudKit container in this app target's Signing & Capabilities in Xcode")

                case .permissionFailure, .notAuthenticated:
                    XCTFail("Simulator or device running this app needs a signed-in iCloud account")

                default:
                    XCTFail("CKError: \(error)")
                }
            }
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

}
