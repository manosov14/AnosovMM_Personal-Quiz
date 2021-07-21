//
//  ResultsViewController.swift
//  Personal Quiz
//
//  Created by brubru on 19.07.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit



class ResultsViewController: UIViewController {
    
    var answersChooser: [Answer] = []
    
    // 1. Передать сюда массив с ответами
    // 2. Определить наиболее часто встерчающийся тип живтоного
    // 3. Отобразить результат в соответсвии с этим животным
    // 4. Избавиться от кнопки возврата назад на экране результатов
    
    @IBOutlet weak var resultLabelOU: UILabel!
    @IBOutlet weak var resultTextOU: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
