//
//  CalculatorTest.swift
//  CalculatorTest
//
//  Created by Guillaume Bisiaux on 24/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest

@testable import CountOnMe
class CalculatorTest: XCTestCase {
    
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    func testGivenExpressionIsCorrect_WhenStringGreaterThanOrEqualTo3_ThenReturnTrue() {
        calculator.addNumbers(numbers: "2")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addEqual()
        XCTAssertEqual(calculator.calcul, "2 + 2 = 4")
    }
    
    func testGivenNumberOne_WhenExpressionDontHaveEnoughElement_ThenAlertMessage() {
        calculator.addNumbers(numbers: "5")
        calculator.addEqual()
        
        //Erreur: Démarrez un nouveau calcul !
        XCTAssertEqual(calculator.calcul, "5")
    }
    
    func testGivenCanAddOperator_WhenCanAddOperator_ThenReturnTrue() {
        calculator.calcul = " 1 + 2 + 3 "
        XCTAssertTrue(calculator.canAddOperator)
    }
    
    func testGivenExpressionHaveResult_WhenExpressionHaveResult_ThenReturnTrue() {
        calculator.calcul = " = 1 "
        XCTAssertTrue(calculator.canAddOperator)
    }
    
    func testGivenNumberOne_WhenTryDivideByZero_ThenInitialiseNil() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "÷")
        calculator.addNumbers(numbers: "0")
        calculator.addEqual()
        
        //Erreur: Impossible de diviser par 0
        XCTAssertEqual(calculator.calcul, "")
    }
    
    func testGivenAddNumber_WhenAddNumber_ThenReturnNumber() {
        calculator.addNumbers(numbers: "3")
        XCTAssertTrue(calculator.calcul == "3")
    }
    
    func testGivenPresentationCalcul_WhenTryMultiplicationOrAddition_ThenShowAlert() {
        calculator.calcul.removeAll()
        calculator.calculInView?("0")
        calculator.addOperator(with: "x")
        calculator.addOperator(with: "+")
        
        //Erreur: Vous ne pouvez pas commencez par un opérateur !
        XCTAssertEqual(calculator.calcul, "")
    }
    
    func testGivenNumberOne_WhenDoFormat_ThenGiveResult() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "÷")
        calculator.addNumbers(numbers: "3")
        calculator.addEqual()
        
        XCTAssertEqual(calculator.calcul, "1 ÷ 3 = 0.333")
    }
    
}
