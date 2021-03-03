//
//  ViewController.swift
//  Yandex
//
//  Created by Lisa Kryshkovskaya on 2/28/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBOutlet weak var gameControl: GameControlViewClass!
    
    func objectTapped() {
        guard gameControl.isGameActive else { return }
        repositionImageWithTimer()
        score += 1
    }
    @IBOutlet weak var scoreLabel: UILabel!
    
    func actionButtonTapped() {
        if gameControl.isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
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
        gameControl.gameTimeLeft = gameControl.gameDuration
        gameControl.isGameActive = true
        updateUI()
    }
    private func stopGame() {
        gameControl.isGameActive = false
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
        gameFieldView.isShapeHidden = !gameControl.isGameActive

    }
    
    @objc private func gameTimerTick() {
        gameControl.gameTimeLeft -= 1
        if gameControl.gameTimeLeft <= 0 {
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
        gameFieldView.shapeHitHandler = {
            [weak self] in self?.objectTapped()
        }
        gameControl.startStopHandler = {
            [weak self] in self?.actionButtonTapped()
        }
        gameControl.gameDuration = 20 
    }


}

