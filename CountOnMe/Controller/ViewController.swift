//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    
    let calculator = Calculator()

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
        
    //MARK:- Actions
    
    @IBAction func didTapNumberButton(_ sender: UIButton) {
        guard let numbers = sender.title(for: .normal) else { return }
        calculator.addNumbers(numbers: numbers)
    }

    @IBAction func didTaptheOperator(_ sender: UIButton) {
        guard let mathOperator = sender.titleLabel?.text else { return }
        calculator.addOperator(with: mathOperator)
    }

    @IBAction func didTapEqualButton(_ sender: UIButton) {
        calculator.addEqual()
    }
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK:- Function
    
    func alertMessage(message: String) -> Void {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    func configure(){
        calculator.alertMessage = alertMessage
        calculator.calculInView = { calcul in
            self.textView.text = calcul
        }
    }
    
}
