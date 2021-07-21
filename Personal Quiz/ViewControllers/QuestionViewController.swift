//
//  QuestionViewController.swift
//  Personal Quiz
//
//  Created by brubru on 19.07.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet weak var rangerdStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet weak var rangedSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            
            rangedSlider.value = answerCount / 2
            rangedSlider.maximumValue = answerCount
        }
    }
    
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    private var answersChooser: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChooser.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnserButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChooser.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChooser.append(currentAnswers[index])
        
        nextQuestion()
    }
}

// MARK: - Private Methods
extension QuestionViewController {
    private func setupUI() {
        
        // Установили для всех экранов скрытые stackView
        for stackView in [singleStackView, multipleStackView, rangerdStackView] {
            stackView?.isHidden = true
        }
        
        //Текущий ответ = 0 эллемент массива ответов Question
        let currentQuestion = questions[questionIndex]
        //Устанавливаем заголовок из 0 объекта массива question
        questionLabel.text = currentQuestion.title
        
        //Считаем значения для шкалы общего прогресса
        let totalProgress = Float(questionIndex) / Float(questions.count)
        //устанавливаем прогресс
        questionProgressView.setProgress(totalProgress, animated: true)
        //определяем заголовок
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        //показать текущие ответы
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            setupUI()
            return
        }
        
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        rangerdStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ResultsViewController {
            guard let resultVC = segue.destination as? ResultsViewController else {return}
            resultVC.answersChooser = answersChooser
        }
    }
}

