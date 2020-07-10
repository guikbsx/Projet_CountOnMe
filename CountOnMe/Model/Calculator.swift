//
//  Stan.swift
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
    
    var isPossibleToStartWithNumber : Bool {
        if calcul >= "0" && calcul <= "9" {
            return elements.count >= 1
        } else {
            alertMessage?("Démarrez plutôt avec un chiffre. 😅")
        }
        return false
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
        if isPossibleToStartWithNumber {
            if canAddOperator {
                calcul.append(" \(mathOperator) ")
            } else {
                alertMessage?("Un operateur est déja mis !")
            }
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
            var operandIndex = 1
            
            ///1. Récupère les premiers nombres et opérateurs nécessaires au calcul
            guard var left: Double = Double(operationsToReduce[0]) else { return }
            var operand = operationsToReduce[1]
            guard var right: Double = Double(operationsToReduce[2]) else { return }
            
            ///2. Check les priorités : s'il y a une multi ou division
            if let index = operationsToReduce.firstIndex(where: { $0 == "x" || $0 == "÷" }) {
                operandIndex = index
                if let newLeft = Double(operationsToReduce[index - 1]) { left = newLeft }
                operand = operationsToReduce[index]
                if let newRight = Double(operationsToReduce[index + 1]) { right = newRight }
            }
            
            ///3. Effectue le calcul
            result = calculate(left: left, right: right, operand: operand)
            
            ///4. Supprime le calcul effectué dans le tableau d'éléments
            for _ in 1...3 {
                operationsToReduce.remove(at: operandIndex - 1)
            }
            
            ///5. Ajoute le résultat du calcul à la place du premier nombre du calcul précédent
            operationsToReduce.insert(format(result: result), at: operandIndex - 1 )
        }
        
        ///6. Récupère le résultat des éléments...
        guard let finalResult = operationsToReduce.first else { return }
        
        ///7. Affiche le résultat du calcul des éléments
        calcul.append("\n= \(finalResult)")
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
