//
//  GameControlViewClass.swift
//  catch-triangle-game
//
//  Created by Lisa Kryshkovskaya on 3/3/21.
//

import UIKit

@IBDesignable
class GameControlViewClass: UIView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBInspectable var gameTimeLeft: Double = 7 {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var isGameActive: Bool = false {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var gameDuration: Double {
        get {
            return stepper.value
        }
        set {
            stepper.value = newValue
            updateUI()
        }
    }
    var startStopHandler:(() -> Void)?
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        startStopHandler?()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // добавляем наше представление в иерархию
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        // получим контейнер содержащий объекты нашего проекта
        let bundle = Bundle(for: type(of: self))
        // получим xib по имени
        let nib = UINib(nibName: "GameControlView", bundle: bundle)
        // создаем и возвращаем сам view
        // форс анврапт (forse unwrapped) всех значений
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func updateUI() {
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
}
