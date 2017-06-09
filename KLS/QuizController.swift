//
//  QuizController.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework
import FirebaseDatabase

class QuizController: UIViewController {
    
    //MARK: -Properties
    var dbRef: FIRDatabaseReference?
    var titleText: String?
    var getTest: [[String:String]]?
    var score = 0
    var falseAnswers = 0
    var trueAnswers = 0
    var questionIndex = 0
    var totalQuestions = 0
    var timerCount = 120
    var timer = Timer()
    let defaults = UserDefaults.standard
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePauseView))
   
    
    lazy var dimView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0
    }
    
    lazy var pauseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
        $0.alpha = 0
    }
    
    lazy var pauseTitle = UILabel().then {
        $0.text = "Пауза"
        $0.font = .systemFont(ofSize: 20, weight: 0.3)
    }
    
    lazy var continueButton = UIButton().then {
        $0.setTitle("Продолжить", for: .normal)
        $0.backgroundColor = HexColor("76B632")
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(hidePauseView), for: .touchUpInside)
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setTitle("Закончить", for: .normal)
        $0.backgroundColor = HexColor("76B632")
        $0.addTarget(self, action: #selector(stopGame), for: .touchUpInside)
        $0.layer.cornerRadius = 5
    }
    
    lazy var mainButton = UIButton().then {
        $0.setTitle("Главное меню", for: .normal)
        $0.backgroundColor = HexColor("F04848")
        $0.addTarget(self, action: #selector(mainMenu), for: .touchUpInside)
        $0.layer.cornerRadius = 5
    }
    
    lazy var mainView = UIView().then {
        $0.layer.cornerRadius = 3 
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("989898")?.cgColor
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 0.5
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
    }
    
    lazy var taskImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
//        $0.image = #imageLiteral(resourceName: "image-title-1")
    }
    
    lazy var taskLabel = UILabel().then {
        $0.text = "Выберите правильный вариант ответа"
    }
    
    lazy var questionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: 0.3)
        $0.text = ""
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    lazy var counterLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: 0.3)
    }
    
    lazy var scoreLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .green
        $0.font = .systemFont(ofSize: 20, weight: 0.3)
    }
    
    lazy var timerView = UIView().then {
        $0.backgroundColor = HexColor("F04848")
        $0.layer.cornerRadius = 3
    }
    
    lazy var timerIconImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "icon-timer")
    }
    
    lazy var timerLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .white
    }
    
    lazy var buttonA = UIButton().then {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("989898")?.cgColor
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 0.5
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
        $0.tag = 0
        $0.addTarget(self, action: #selector(answerClicked(_:)), for: .touchUpInside)
        
        $0.setTitle("Answer A", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    lazy var buttonB = UIButton().then {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("989898")?.cgColor
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 0.5
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
        $0.tag = 1
        $0.addTarget(self, action: #selector(answerClicked(_:)), for: .touchUpInside)
        
        $0.setTitle("Answer B", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    lazy var buttonC = UIButton().then {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("989898")?.cgColor
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 0.5
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
        $0.tag = 2
        $0.addTarget(self, action: #selector(answerClicked(_:)), for: .touchUpInside)
        
        $0.setTitle("Answer C", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    lazy var buttonD = UIButton().then {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .white
        $0.layer.shadowColor = HexColor("989898")?.cgColor
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowOpacity = 0.5
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = false
        $0.tag = 3
        $0.addTarget(self, action: #selector(answerClicked(_:)), for: .touchUpInside)
        
        $0.setTitle("Answer D", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    //MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
        automaticallyAdjustsScrollViewInsets = true
        view.isUserInteractionEnabled = true
        dimView.isUserInteractionEnabled = true
        if defaults.integer(forKey: "language") == 0{
            pauseTitle.text = "Пауза"
            continueButton.setTitle("Продолжить", for: .normal)
            cancelButton.setTitle("Закончить", for: .normal)
            mainButton.setTitle("Главное меню", for: .normal)
            taskLabel.text = "Выберите правильный вариант ответа"
        } else {
            pauseTitle.text = "Тоқтату"
            continueButton.setTitle("Жалғастыру", for: .normal)
            cancelButton.setTitle("Бітіру", for: .normal)
            mainButton.setTitle("Басты бет", for: .normal)
            taskLabel.text = "Дұрыс жауапты таңдаңыз"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setUpNavBar()
        setUpNeeds()
        dismissController()
        dbRef = FIRDatabase.database().reference().child("test-object")
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Setups
    
    func setupViews() {
        
        
        dimView.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .white
        
        [mainView, timerView, scoreLabel, counterLabel, taskLabel, taskImage, questionLabel, buttonA, buttonB, buttonC, buttonD, dimView, pauseView].forEach {
            view.addSubview($0)
        }
        
        [timerIconImageView, timerLabel].forEach {
            timerView.addSubview($0)
        }
        
        [pauseTitle, continueButton, cancelButton, mainButton].forEach {
            pauseView.addSubview($0)
        }
        
    }
    
    func setupConstraints() {
        constrain(dimView, pauseView, view , pauseTitle, continueButton) {
            $0.edges == $2.edges
            
            $1.height == $2.height/2
            $1.center == $2.center
            $1.width == $2.width - 20
            
            $3.top == $1.top + 15
            $3.centerX == $1.centerX
            
            $4.top == $3.bottom + 20
            $4.centerX == $3.centerX
            $4.width == $2.width - 50
            $4.height == 60
        }
        
        constrain(cancelButton, continueButton, mainButton) {
            $0.top == $1.bottom + 20
            $0.centerX == $1.centerX
            $0.width == $1.width
            $0.height == $1.height
            
            $2.top == $0.bottom + 20
            $2.centerX == $1.centerX
            $2.width == $1.width
            $2.height == $1.height
        }
        
        constrain(mainView, view, taskLabel) {
            $0.width == $1.width - 20
            $0.centerX == $1.centerX
            $0.top == $1.top + 20
            $0.height == $1.height/2.5
            
            $2.top == $0.bottom + 20
            $2.centerX == $0.centerX
        }
        
        constrain(timerView, mainView, timerLabel, timerIconImageView, counterLabel) {
            $0.top == $1.top + 15
            $0.centerX == $1.centerX
            $0.width == 70
            $0.height == 30
            
            $3.leading == $0.leading + 5
            $3.centerY == $0.centerY
            
            $2.leading == $3.trailing + 5
            $2.centerY == $0.centerY
            $2.trailing == $0.trailing + 5
            
            $4.centerY == $0.centerY
            $4.trailing == $1.trailing - 20
        }
        
        constrain(taskImage, questionLabel, mainView){
            $0.leading == $2.leading + 10
            $0.trailing == $2.trailing - 10
            $0.centerY == $2.centerY
            $0.top == $2.top + 60
            $0.bottom == $2.bottom - 10
            
            
            $1.leading == $2.leading + 10
            $1.trailing == $2.trailing - 10
            $1.centerY == $2.centerY
            $1.top == $2.top + 50
            $1.bottom == $2.bottom - 10
        }
        
        constrain(buttonA, view, taskLabel, buttonB, buttonC) {
            $0.top == $2.bottom + 20
            $0.leading == $1.leading + 10
            $0.width == $1.width / 2 - 15
            $0.height == $1.height/5
            
            $3.top == $0.top
            $3.leading == $0.trailing + 10
            $3.width == $0.width
            $3.height == $0.height
            
            $4.top == $0.bottom + 10
            $4.leading == $0.leading
            $4.width == $0.width
            $4.height == $0.height
        }
        
        constrain(buttonC, buttonD) {
            $1.top == $0.top
            $1.leading == $0.trailing + 10
            $1.width == $0.width
            $1.height == $0.height
        }
        
        constrain(timerView, mainView, scoreLabel) {
            $2.centerY == $0.centerY
            $2.leading == $1.leading + 20
        }
    }
    
    func setUpNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-pause"), style: .plain, target: self, action: #selector(showPauseView))
        
        title = titleText
        
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = HexColor("0070D5")
    }
    
    //MARK: Actions
    
    func dismissController(){
        dismiss(animated: true, completion: nil)
    }
    
    func showPauseView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dimView.alpha = 0.5
            self.pauseView.alpha = 1
        })
        timer.invalidate()
    }
    
    func hidePauseView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dimView.alpha = 0
            self.pauseView.alpha = 0
        })
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target:self,
                                     selector: #selector(timerRun),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()
    }
    
    //game func
    func toggleButtons(_ toggle: Bool ){
        buttonA.isUserInteractionEnabled = toggle
        buttonB.isUserInteractionEnabled = toggle
        buttonC.isUserInteractionEnabled = toggle
        buttonD.isUserInteractionEnabled = toggle
    }
    
    func returnColors(){
        buttonA.backgroundColor = UIColor.white
        buttonB.backgroundColor = UIColor.white
        buttonC.backgroundColor = UIColor.white
        buttonD.backgroundColor = UIColor.white
    }
    
    func clearButton(){
        buttonA.backgroundColor = UIColor.clear
        buttonB.backgroundColor = UIColor.clear
        buttonC.backgroundColor = UIColor.clear
        buttonD.backgroundColor = UIColor.clear
    }
    
    func addScore() -> String{
        score = score + 10
        return String(score)
    }
    
    func minusScore() -> String{
        score = score - 5
        return String(score)
    }
    
    func showQuestion(){
        print(questionIndex)
        questionLabel.text = getTest?[questionIndex]["question"]
        buttonA.setTitle(getTest?[questionIndex]["A"], for: .normal)
        buttonB.setTitle(getTest?[questionIndex]["B"], for: .normal)
        buttonC.setTitle(getTest?[questionIndex]["C"], for: .normal)
        buttonD.setTitle(getTest?[questionIndex]["D"], for: .normal)
        questionIndex = questionIndex + 1
        counterLabel.text = "\(questionIndex)/\(totalQuestions)"
        toggleButtons(true)
        returnColors()
    }
    
    func answerClicked(_ button: UIButton){
        toggleButtons(false)
        let answer = Int((getTest?[questionIndex-1]["answer"]!)!)
        if button.tag == answer {
            button.backgroundColor = UIColor.green
            scoreLabel.text = addScore()
            trueAnswers = trueAnswers + 1
            
        } else {
            scoreLabel.text = String(minusScore())
            if buttonA.tag == answer{
                buttonA.backgroundColor = .green
            } else if buttonB.tag == answer{
                buttonB.backgroundColor = .green
            } else if buttonC.tag == answer{
                buttonC.backgroundColor = .green
            } else if buttonD.tag == answer{
                buttonD.backgroundColor = .green
            }
            button.backgroundColor = UIColor.red
            falseAnswers = falseAnswers + 1
        }
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(showQuestion), userInfo: nil, repeats: false)
    }
    
    func timerRun(){
        timerCount = timerCount - 1
        timerLabel.text = String(timerCount)
        if timerCount == 0 {
            stopGame()
        }
    }
    
    func setUpNeeds(){
        timer = Timer.scheduledTimer(timeInterval: 1,
                                         target:self,
                                         selector: #selector(timerRun),
                                         userInfo: nil,
                                         repeats: true)
        timer.fire()
        totalQuestions = (getTest?.count)!
        counterLabel.text = "1/\(totalQuestions)"
        showQuestion()
    }
    
    func stopGame(){
        UIView.animate(withDuration: 0.5, animations: {
            self.dimView.alpha = 0
            self.pauseView.alpha = 0
        })
        timerCount = 180
        timerLabel.text = "0"
        guard let score = scoreLabel.text else { return }
        var alert = UIAlertController()
        if defaults.integer(forKey: "language") == 0{
             alert = UIAlertController(title: "Твой счет: \(score) \n Правильные ответы: \(trueAnswers) \n Не правильные ответы: \(falseAnswers)", message: "Спасибо за тест:)", preferredStyle: .alert)
        } else {
             alert = UIAlertController(title: "Ұпай: \(score) \n Дұрыс жауабтар саны: \(trueAnswers) \n Қате жауабтар саны: \(falseAnswers)", message: "Рақмет:)", preferredStyle: .alert)
        }
        
        
                    alert.addTextField { (textField) in
                        textField.placeholder = "Жасур"
                        textField.textAlignment = .center
                    }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            guard let name = textField?.text, let score = self.scoreLabel.text else {return}
            
            let test = Test(name: name, score: score, subject: "Math", trueAnswers: "\(self.trueAnswers)", falseAnswers: "\(self.falseAnswers)")
            
            let postRef = self.dbRef?.child((name.lowercased()))
            postRef?.setValue(test.toAnyObject())
            
            self.dismissController()
            alert?.dismiss(animated: true, completion: nil)
            self.mainMenu()
            
        }))
        self.present(alert, animated: true, completion: nil)
        self.timer.invalidate()
    }
    
    func mainMenu(){
        let destVC = HomeController()
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}

