////
////  PasswordTest.swift
////  ParPals
////
////  Created by Nick Deda on 11/13/24.
////
//
//import XCTest
//
//@MainActor
//final class PasswordTest: XCTestCase {
//    
//    var vm: ViewModel!
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        vm = ViewModel()
//    }
//    
//    override func tearDown() {
//        vm = nil
//        super.tearDown()
//    }
//    
//    func testIsPasswordValid() async throws {
//        // Valid cases
//        let validPassword1 = vm.isPasswordValid("Password1!")
//        let validPassword2 = vm.isPasswordValid("Pass1@123")
//        XCTAssertTrue(validPassword1)
//        XCTAssertTrue(validPassword2)
//        
//        // Invalid cases
//        let invalidPassword1 = vm.isPasswordValid("miss!")
//        let invalidPassword2 = vm.isPasswordValid("thisiswaytolongtowork1!")
//        let invalidPassword3 = vm.isPasswordValid("Password!")
//        let invalidPassword4 = vm.isPasswordValid("Password1")
//        let invalidPassword5 = vm.isPasswordValid("12345678!")
//        
//        XCTAssertFalse(invalidPassword1)
//        XCTAssertFalse(invalidPassword2)
//        XCTAssertFalse(invalidPassword3)
//        XCTAssertFalse(invalidPassword4)
//        XCTAssertFalse(invalidPassword5)
//    }
//}
