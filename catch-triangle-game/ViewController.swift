//
//  ViewController.swift
//  Yandex
//
//  Created by Lisa Kryshkovskaya on 2/28/21.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    
    func objectTapped() {
        guard isGameActive else { return }
        repositionImageWithTimer()
        score += 1
    }
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
    private var isGameActive = false
    private var gameTimeLeft: TimeInterval = 30
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 2
    private var score = 0
    
    private func startGame() {
        score = 0
        repositionImageWithTimer()
        gameTimer?.invalidate() // останавливаем предыдущий таймер перед началом игры
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1, // время интервала в секундах
            target: self, // объект, у которого нужно вызвать таймер
            selector: #selector(gameTimerTick),
            userInfo: nil,
            repeats: true)
        gameTimeLeft = stepper.value
        isGameActive = true
        updateUI()
    }
    private func stopGame() {
        isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Последний счет: \(score)"
    }
    
    private func repositionImageWithTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: displayDuration,
            target: self,
            selector: #selector(moveImage),
            userInfo: nil,
            repeats: true)
        timer?.fire() // чтобу перемещение было вызвано сразу, а не через несколько секунд
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !isGameActive
        stepper.isEnabled = !isGameActive
        if isGameActive {
            timeLabel.text = "Осталось \(Int(gameTimeLeft)) сек"
            actionButton.setTitle("Остановить", for: .normal)
        } else {
            gameTimeLeft = stepper.value
            timeLabel.text = "Время: \(Int(gameTimeLeft)) сек"
            actionButton.setTitle("Начать", for: .normal)
        }
    }
    
    @objc private func gameTimerTick() {
        gameTimeLeft -= 1
        if gameTimeLeft <= 0 {
            stopGame()
        } else {
            updateUI()
        }
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        updateUI()
        gameFieldView.shapeHitHandler = { [weak self] in
            self?.objectTapped()
        }
    }


}

