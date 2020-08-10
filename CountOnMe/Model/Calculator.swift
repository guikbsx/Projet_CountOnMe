//
//  Calculator.swift
//  CountOnMe
//
//  Created by Guillaume Bisiaux on 10/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
    
    // MARK: - Properties
    
    var alertMessage: ((String) -> Void)?
    var calculInView: ((String) -> Void)?
        
    var calcul: String {
        didSet {
            calculInView?(calcul)
        }
    }
    
    var result = ""
    
    private var elements: [String] {
        return calcul.split(separator: " ").map { "\($0)" }
    }
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷"
    }
    
    var expressionHaveResult: Bool {
        return calcul.firstIndex(of: "=") != nil
    }
    
    var isDivideByZero: Bool {
        return calcul.contains("÷ 0")
    }
    
    //MARK:- Init
    
    init() {
        self.calcul = ""
    }
    
    //MARK:- Functions
    
    func addNumbers(numbers: String) {
        if expressionHaveResult {
            self.calcul = ""
        }
        self.calcul.append(numbers)
    }
    
    func addOperator(with mathOperator: String) {
        if expressionHaveResult {
            calcul.removeAll()
            calcul.append(String(result))
        }
        
        if canAddOperator {
            calcul.append(" \(mathOperator) ")
        } else {
            alertMessage?("Un operateur est déja mis !")
        }
    }
    
    func deleteAll() {
        calcul.removeAll()
        calculInView?("")
    }
    
    func delete() {
        guard calcul.count >= 1 else { return }
        
        if expressionHaveResult {
            calcul.removeAll()
            calcul.append(String(result))
        }
        
        if canAddOperator {
            calcul.removeLast()
        } else {
            calcul.removeLast()
            calcul.removeLast()
            calcul.removeLast()
        }
    }
    
    func addEqual() {
        
        ///Vérifie que ça ne finit par un opérateur
        guard expressionIsCorrect else {
            alertMessage?("Entrez une expression correcte !")
            return
        }
        
        ///Vérifie qu'il y a assez d'éléments pour faire le cacul
        guard expressionHaveEnoughElement else {
            alertMessage?("Démarrez un nouveau calcul !")
            return
        }
        
        
        ///Vérifie qu'il n'y a pas de division par 0
        guard !isDivideByZero else {
            alertMessage?("Impossible de diviser par 0 !")
            calcul = ""
            return
        }
        
        ///Stocke les données des éléments en local pour les traiter
        var operationsToReduce = elements
        
        ///Tant qu'il y a plus d'un élément à calculer...
        while operationsToReduce.count > 1 {
            let result: Double
            let operandIndex = operationsToReduce.firstIndex(where: { $0 == "x" || $0 == "÷" }) ?? 1
            
            ///1. Récupère les premiers nombres et opérateurs nécessaires au calcul
            guard let left: Double = Double(operationsToReduce[operandIndex-1]) else { return }
            let operand = operationsToReduce[operandIndex]
            guard let right: Double = Double(operationsToReduce[operandIndex+1]) else { return }

            ///2. Effectue le calcul
            result = calculate(left: left, right: right, operand: operand)
            
            ///3. Supprime le calcul effectué dans le tableau d'éléments
            for _ in 1...3 {
                operationsToReduce.remove(at: operandIndex - 1)
            }
            
            ///4. Ajoute le résultat du calcul à la place du premier nombre du calcul précédent
            operationsToReduce.insert(format(result: result), at: operandIndex - 1 )
        }
        
        ///5. Récupère le résultat des éléments...
        guard let finalResult = operationsToReduce.first else { return }
        
        ///6. Affiche le résultat du calcul des éléments
        calcul.append(" = \(finalResult)")
        result = finalResult
    }

    ///Effectue le calcul entre deux nombres et un opérateur
    func calculate(left: Double, right: Double, operand: String) -> Double {
        let result: Double
        switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷": result = left / right
            case "x": result = left * right
            default: return 0.0
        }
        return result
    }
    
    ///Formatte le résultat pour éviter les décimals à l'infini
    private func format(result: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        guard let resultFormated = formatter.string(from: NSNumber(value: result)) else { return String() }
        guard resultFormated.count <= 10 else { return String(result) }
        return resultFormated
    }
    
}
