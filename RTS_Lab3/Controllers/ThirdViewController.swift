//
//  ThirdViewController.swift
//  RTS_Lab3
//
//  Created by dima on 08.04.2021.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet var a: UITextField!
    @IBOutlet var b: UITextField!
    @IBOutlet var c: UITextField!
    @IBOutlet var d: UITextField!
    @IBOutlet var y: UITextField!

    @IBOutlet var bestFitnessResult: UILabel!
    @IBOutlet var worstFitnessResult: UILabel!
    @IBOutlet var bestNumOfIter: UILabel!
    @IBOutlet var worstNumOfIter: UILabel!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        a.resignFirstResponder()
        b.resignFirstResponder()
        c.resignFirstResponder()
        d.resignFirstResponder()
        y.resignFirstResponder()
        
        let gen = GeneticAlg(a: Int(a.text!)!, b: Int(b.text!)!, c: Int(c.text!)!, d: Int(d.text!)!, y: Int(y.text!)!)
        gen.fitness()
        gen.calculatePercentage()
        gen.roulette()
        var result = gen.crossAndMutation()
        bestFitnessResult.text = "Best fitness result: \(result[0].Genotype)"
        bestNumOfIter.text = "Number of iterations for best: \(result[0].Iterations)"
        worstFitnessResult.text = "Worst fitness result: \(result[1].Genotype)"
        worstNumOfIter.text = "Number of iterations for worst: \(result[1].Iterations)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

class GeneticAlg {
    var a: Int
    var b: Int
    var c: Int
    var d: Int
    var y: Int
    
    var population = [[Int]: Int]()
    var roulettePerc = [[Int]: Float]()
    var arrOfChosenOnes = [[Int]]()
    
    init(a: Int, b: Int, c: Int, d:Int, y:Int) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.y = y
    }
    
    func calculateEquation(x1:Int, x2:Int, x3:Int, x4:Int) -> Int{
        return a*x1 + b*x2 + c*x3 + d*x4
    }
    
    func fitness() {
        for _ in 1...4 {
            let arr = [Int.random(in: 1...(y/2)),
                       Int.random(in: 1...(y/2)),
                       Int.random(in: 1...(y/2)),
                       Int.random(in: 1...(y/2))]
        
            let delta = abs(y - calculateEquation(x1: arr[0], x2: arr[1], x3: arr[2], x4: arr[3]))
            population[arr] = delta
        }
        
    }
    
    func calculatePercentage() {
        var rouletteParam:Double = 0
        for (_, delta) in population{
            rouletteParam += 1.0/Double(delta)
        }
        for (arr, delta) in population{
            roulettePerc[arr] = (Float(1.0/Double(delta)/rouletteParam) * 100).rounded() / 100
        }
    }
    
    func roulette(){
        for _ in 1...4 {
            var currentStartInterval:Float = 0
            var currentEndInterval:Float = 0
            let rand = (Float.random(in: 0...1) * 100).rounded() / 100
            for (arr, perc) in roulettePerc {
                currentEndInterval = currentStartInterval + perc - 0.01
   
                
                if(rand >= currentStartInterval && rand <= currentEndInterval) {
                    if(!arrOfChosenOnes.contains(arr)) {
                        arrOfChosenOnes.append(arr)
                    }
                    break
                }
                currentStartInterval += perc
            }
            
        }
        arrOfChosenOnes.sort {
            roulettePerc[$0]! > roulettePerc[$1]!
        }
    }
    
    func crossAndMutation() -> [(Genotype: [Int], Iterations: Int)] {
        let indexToCross = Int.random(in: 1..<arrOfChosenOnes[0].count)
        var arrWithCrossed = arrOfChosenOnes[0...1]
        var delta = [Int]()
        var result = [(Genotype: [Int], Iterations: Int)]()
        
        for i in 0..<indexToCross {
            arrWithCrossed[0][i] = arrOfChosenOnes[1][i]
            arrWithCrossed[1][i] = arrOfChosenOnes[0][i]
        }
        
        for (index, num) in arrWithCrossed.enumerated() {
            delta.append(abs(y - calculateEquation(x1: num[0], x2: num[1], x3: num[2], x4: num[3])))
        }
        
        let combined = zip(arrWithCrossed, delta).sorted {$0.1 < $1.1}
        let sortedCrossed = combined.map{$0.0}
        
        
        for (currentGenotype) in sortedCrossed {
            var chosenGenotype = currentGenotype
            var calculated = calculateEquation(x1: chosenGenotype[0], x2: chosenGenotype[1], x3: chosenGenotype[2], x4: chosenGenotype[3])
            var counter = 0
            while(calculated != y) {
                counter += 1
                let rand = Int.random(in: 0..<chosenGenotype.count)
                if (calculated > y) {
                    if(chosenGenotype[rand] == 0) {
                        continue
                    }
                    chosenGenotype[rand] -= 1
                } else {
                    chosenGenotype[rand] += 1
                }
                calculated = calculateEquation(x1: chosenGenotype[0], x2: chosenGenotype[1], x3: chosenGenotype[2], x4: chosenGenotype[3])
            }
            result.append((Genotype: chosenGenotype, Iterations: counter))
        }
        
//        if (result == []){
//            let randIndex = Int.random(in: 0...1)
//            var chosenGenotype = arrWithCrossed[randIndex]
//            var calculated = calculateEquation(x1: chosenGenotype[0], x2: chosenGenotype[1], x3: chosenGenotype[2], x4: chosenGenotype[3])
//            while(calculated != y) {
//                let rand = Int.random(in: 0..<chosenGenotype.count)
//                if (calculated > y) {
//                    if(chosenGenotype[rand] == 0) {
//                        continue
//                    }
//                    chosenGenotype[rand] -= 1
//                } else {
//                    chosenGenotype[rand] += 1
//                }
//                calculated = calculateEquation(x1: chosenGenotype[0], x2: chosenGenotype[1], x3: chosenGenotype[2], x4: chosenGenotype[3])
//            }
//            result = chosenGenotype
//
//        }
        
        
        return result

    }
    
}
