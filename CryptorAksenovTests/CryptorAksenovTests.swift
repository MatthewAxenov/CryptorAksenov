//
//  CryptorAksenovTests.swift
//  CryptorAksenovTests
//
//  Created by Матвей on 18.10.2023.
//

import XCTest
import Security
@testable import CryptorAksenov

final class CryptorAksenovTests: XCTestCase {
    
    func testCryptor() async throws {
        
        CoreDataManager.shared.deleteAll()
                
        let inputStrings = (0..<100).map { _ in UUID().uuidString }
        
        let publicKey = try CryptorKeysHelper.returnPublicKey()
        
        for str in inputStrings {
            do {
                try await CryptorAksenov.store(string: str, key: publicKey)
            } catch {
                XCTFail("Error occurred while storing: \(error)")
            }
        }
        let storedStrings = try await CryptorAksenov.strings
        XCTAssertEqual(inputStrings, storedStrings)
    }
    
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
