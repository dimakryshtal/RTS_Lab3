//
//  FirstViewController.swift
//  RTS_Lab3
//
//  Created by dima on 30.03.2021.
//

import UIKit

class FirstViewController: UIViewController {
    
    
    @IBOutlet var text: UITextField!
    @IBOutlet var outputLabel: UILabel!
    @IBOutlet var numberOfIter: UILabel!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.delegate = self
        text.keyboardType = .numberPad
        outputLabel.text = ""
        button.addTarget(self, action: #selector(didTapCalculateButton), for: .touchUpInside)
        
    }
    @objc func didTapCalculateButton() {
        text.resignFirstResponder()
        guard let textEntered = text.text, let number = Int(textEntered) else {return}
        if (number % 2 == 0) {
            outputLabel.text = "Enter odd number"
            return
        }
        
        var num = ceil(sqrt(Double(number)))
        var counter = 0
        while(sqrt(pow(num, 2) - Double(number)) != floor(sqrt(pow(num, 2) - Double(number)))) {
            num += 1
            counter += 1
        }
        outputLabel.text = "\(Int(num - sqrt(pow(num, 2) - Double(number)))), \(Int(num + sqrt(pow(num, 2) - Double(number))))"
        numberOfIter.text = "Number of iterations: \(counter)"
    
    }
}

extension FirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
