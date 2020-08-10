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
    
    func testGivenAddNumber_WhenAddNumber_ThenReturnNumber() {
        calculator.addNumbers(numbers: "3")
        XCTAssertTrue(calculator.calcul == "3")
    }
    
    func testGivenExpressionIsCorrect_WhenStringGreaterThanOrEqualTo3_ThenReturnTrue() {
        calculator.addNumbers(numbers: "2")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addEqual()
        XCTAssertEqual(calculator.calcul, "2 + 2 = 4")
    }
    
    func testGivenCanAddOperator_WhenCanAddOperator_ThenReturnTrue() {
        calculator.calcul = " 1 + 2 + 3 "
        XCTAssertTrue(calculator.canAddOperator)
    }
    
    func testGivenExpressionHaveResult_WhenExpressionHaveResult_ThenReturnTrue() {
        calculator.calcul = " = 1 "
        XCTAssertTrue(calculator.canAddOperator)
    }
    
    func testGivenDeleteField_WhenHaveCalculation_ThenDeleteAll() {
        calculator.addNumbers(numbers: "1")
        
        calculator.deleteAll()
        XCTAssertEqual(calculator.calcul, "")
    }
    
    func testGivenDelete_WhenCanDelete_ThenDelete() {
        calculator.addNumbers(numbers: "1")
        
        calculator.delete()
        XCTAssertEqual(calculator.calcul, "")
    }
    
    func testGivenNumberOne_WhenExpressionDontHaveEnoughElement_ThenAlertMessage() {
        calculator.addNumbers(numbers: "5")
        //Erreur: Démarrez un nouveau calcul !
        let expectation = XCTestExpectation(description: "")
        calculator.alertMessage = { msg in
            XCTAssert(msg == "Démarrez un nouveau calcul !")
            expectation.fulfill()
        }
        calculator.addEqual()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testGivenNumberOne_WhenTryDivideByZero_ThenAlertMessage() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "÷")
        calculator.addNumbers(numbers: "0")
        
        let expectation = XCTestExpectation(description: "")
        calculator.alertMessage = { msg in
            XCTAssert(msg == "Impossible de diviser par 0 !")
            expectation.fulfill()
        }
        
        calculator.addEqual()
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
    func testGivenMultiplication_WhenTryAddition_ThenAlertMessage() {
        calculator.calcul.removeAll()
        calculator.calculInView?("")
        calculator.addOperator(with: "x")
        calculator.addOperator(with: "+")
        
        let expectation = XCTestExpectation(description: "")
        calculator.alertMessage = { msg in
            XCTAssert(msg == "Entrez une expression correcte !")
            expectation.fulfill()
        }
        
        calculator.addEqual()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGivenNumberOne_WhenDoFormat_ThenGiveResult() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "÷")
        calculator.addNumbers(numbers: "3")
        
        calculator.addEqual()
        XCTAssertEqual(calculator.calcul, "1 ÷ 3 = 0.333")
    }
        
    func testGivenPriority_WhenAddMultiplicationAndAddition_ThenGiveResult() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addOperator(with: "x")
        calculator.addNumbers(numbers: "3")
        
        calculator.addEqual()
        XCTAssertEqual(calculator.calcul, "1 + 2 x 3 = 7")
    }
    
    func testExpressionHaveResult_WhenAddOperator_ThenGiveResult() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addEqual()

        XCTAssertTrue(calculator.expressionHaveResult)
        calculator.addOperator(with: "+")
        XCTAssertEqual(calculator.calcul, "3 + ")
    }
    
    func testExpressionHaveResult_WhenAddNumber_ThenGiveResult() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addEqual()

        XCTAssertTrue(calculator.expressionHaveResult)
        calculator.addNumbers(numbers: "1")
        XCTAssertEqual(calculator.calcul, "1")
    }
    
    func testExpressionHaveResult_WhenDelete_ThenGiveResult() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addEqual()
        
        calculator.delete()
        XCTAssertEqual(calculator.calcul, "")
    }
    
    func testDeleteOperator_WhenAddOperator_ThenGiveResult() {
        calculator.addNumbers(numbers: "1")
        calculator.addOperator(with: "+")
        calculator.addNumbers(numbers: "2")
        calculator.addEqual()
        calculator.addOperator(with: "+")
        calculator.delete()
        XCTAssertEqual(calculator.calcul, "3")
    }
    
}
