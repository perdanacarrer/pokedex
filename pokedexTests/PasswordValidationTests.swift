//
//  PasswordValidationTests.swift
//  pokedexTests
//
//  Created by oscar perdana on 04/06/23.
//

import XCTest
@testable import pokedex

class PasswordValidationTests: XCTestCase {
    
    func testIsPasswordEightPlusCharacter() {
        XCTAssertTrue("password123".isPasswordEightPlusCharacter())
        XCTAssertTrue("thisisalongpassword".isPasswordEightPlusCharacter())
        XCTAssertFalse("short".isPasswordEightPlusCharacter())
    }
    
    func testIsPasswordContainUppercaseLetter() {
        XCTAssertTrue("Password123".isPasswordContainUppercaseLetter())
        XCTAssertTrue("UPPERCASE".isPasswordContainUppercaseLetter())
        XCTAssertFalse("lowercase".isPasswordContainUppercaseLetter())
        XCTAssertFalse("123456".isPasswordContainUppercaseLetter())
    }
    
    func testIsPasswordContainLowercaseLetter() {
        XCTAssertTrue("Password123".isPasswordContainLowercaseLetter())
        XCTAssertTrue("lowercase".isPasswordContainLowercaseLetter())
        XCTAssertFalse("UPPERCASE".isPasswordContainLowercaseLetter())
        XCTAssertFalse("123456".isPasswordContainLowercaseLetter())
    }
    
    func testIsPasswordContainSymbolOrNumber() {
        XCTAssertTrue("Password123".isPasswordContainSymbolOrNumber())
        XCTAssertTrue("123456".isPasswordContainSymbolOrNumber())
        XCTAssertTrue("Password!".isPasswordContainSymbolOrNumber())
        XCTAssertFalse("password".isPasswordContainSymbolOrNumber())
        XCTAssertFalse("!@#$%^&*".isPasswordContainSymbolOrNumber())
    }
    
}

