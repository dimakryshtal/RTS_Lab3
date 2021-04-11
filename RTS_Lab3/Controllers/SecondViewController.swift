//
//  SecondViewController.swift
//  RTS_Lab3
//
//  Created by dima on 06.04.2021.
//

import UIKit

class SecondViewController: UIViewController {
 
    @IBOutlet var button: UIButton!
    @IBOutlet var sigmaField: UITextField!
    @IBOutlet var iterField: UITextField!
    @IBOutlet var resutLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func calculateButtonTapped() {
        iterField.resignFirstResponder()
        sigmaField.resignFirstResponder()
        let perc = Perceptron(iterations: Int(iterField.text!)!, sigma: Float(sigmaField.text!)!)
        let result = perc.main()
        resutLabel.text = "w1:\(result.0!); w2:\(result.1!)"
        
    }

}


class Perceptron {
    var points = [(0,6),(1,5),(3,3),(2,4)]
    var learningSpeed:Float? = nil
    var iterations:Int? = nil
    let p: Float = 4
    var y: Float? = nil
    var delta: Float? = nil
    var w1: Float = 0
    var w2: Float = 0
  
    init(iterations: Int, sigma: Float) {
        self.iterations = iterations
        self.learningSpeed = sigma
    }
    func main() -> (Float?, Float?){
        var i = 0
        while (i < iterations!) {
            let currentPoint = points[i % points.count]
            
            y = Float(currentPoint.0) * w1 + Float(currentPoint.1) * w2
            if((y! > p && (i % 4 == 0 || i % 4 == 1)) || (y! < p && (i % 4 == 2 || i % 4 == 3))) {
                var res = true
                for j in 0..<points.count {
                    if(j < 2) {
                        res = (Float(points[j].0) * w1 + Float(points[j].1) * w2) > p
                    } else {
                        res = (Float(points[j].0) * w1 + Float(points[j].1) * w2) < p
                    }
                    if(!res){
                        break
                    }
                    
                }
                if(res) {
                    return (w1,w2)
                }
                
            }
            delta = p - y!
            w1 = w1 + delta! * learningSpeed! * Float(currentPoint.0)
            w2 = w2 + delta! * learningSpeed! * Float(currentPoint.1)


            i += 1
        }
        return (nil,nil)
    }
    
    
    
    
}
