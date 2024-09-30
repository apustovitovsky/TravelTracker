import UIKit
import SnapKit

// MARK: - PinViewProtocol

protocol PinViewProtocol: UIViewController {
    func updatePinPrompt(with text: String)
    func updatePinCircles(count: Int)
}

// MARK: - PinView

final class PinViewController: UIViewController {

    private let presenter: PinPresenterProtocol

    // Dimensions for buttons and circles
    private enum Dimensions {
        static let circleSize: CGFloat = 16
        static let buttonSize: CGFloat = 56
        static let circleSpacing: CGFloat = 24
        static let buttonSpacing: CGFloat = 40
        static let verticalOffset: CGFloat = 160
        static let promptToCirclesOffset: CGFloat = 32
        static let bottomInset: CGFloat = 48
    }

    // UI elements: Label for pin prompt
    private lazy var pinPromptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // StackView for pin circles (visual representation of entered pin digits)
    private lazy var pinCirclesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = Dimensions.circleSpacing
        return stackView
    }()
    
    // StackView for pin keyboard (used for pin digit input)
    private lazy var pinKeyboardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = Dimensions.buttonSpacing
        return stackView
    }()
    
    init(presenter: PinPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "bg")
        
        setupLayout()
        setupPinCircles()
        setupPinKeyboard()
        
        presenter.viewDidLoad()
    }
    
    // Configures the layout of the views using SnapKit
    private func setupLayout() {
        view.addSubview(pinPromptLabel)
        view.addSubview(pinCirclesStackView)
        view.addSubview(pinKeyboardStackView)
        
        pinPromptLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Dimensions.verticalOffset)
            make.centerX.equalToSuperview()
        }
        
        pinCirclesStackView.snp.makeConstraints { make in
            make.top.equalTo(pinPromptLabel.snp.bottom).offset(Dimensions.promptToCirclesOffset)
            make.centerX.equalToSuperview()
        }
        
        pinKeyboardStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.bottomInset)
            make.centerX.equalToSuperview()
        }
    }

    // Creates pin circles to represent the number of digits entered
    private func setupPinCircles() {
        for _ in 0 ..< presenter.getPinLength() {
            let pinCircleView = UIView()
            pinCircleView.backgroundColor = .init(named: "bgLight")
            pinCircleView.layer.cornerRadius = Dimensions.circleSize / 2
            
            pinCirclesStackView.addArrangedSubview(pinCircleView)
            
            pinCircleView.snp.makeConstraints { make in
                make.width.height.equalTo(Dimensions.circleSize)
            }
        }
    }
    
    // Configures the keyboard for entering pin digits
    private func setupPinKeyboard() {
        let buttonTitles = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "⌫"]
        ]
        
        // Iterates over the button titles to create rows of buttons
        buttonTitles.forEach { row in
            let rowStackView = createRowStackView(for: row)
            pinKeyboardStackView.addArrangedSubview(rowStackView)
        }
    }

    // Creates a horizontal stack view for each row of pin keyboard buttons
    private func createRowStackView(for titles: [String]) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .equalCentering
        rowStackView.spacing = Dimensions.buttonSpacing
        
        titles.forEach { title in
            let button = createButton(with: title)
            rowStackView.addArrangedSubview(button)
        }
        
        return rowStackView
    }
    
    // Creates an individual button for the pin keyboard
    private func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = Dimensions.buttonSize / 2

        if let _ = Int(title) {
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        } else {
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        }

        button.addTarget(self, action: #selector(digitButtonPressed(_:)), for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(Dimensions.buttonSize)
        }
        
        return button
    }
    
    // Handles the pin keyboard button press events
    @objc private func digitButtonPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        if let digit = Int(title) {
            presenter.addDigitToPin(digit: digit)
        } else if title == "⌫" {
            presenter.removeLastDigitFromPin()
        }
    }
}

extension PinViewController: PinViewProtocol {
  
    // Updates the pin circles based on the number of digits entered
    func updatePinCircles(count: Int) {
        (0 ..< pinCirclesStackView.arrangedSubviews.count).forEach { index in
            let circleView = pinCirclesStackView.arrangedSubviews[index]
            let isActive = index < count

            if isActive {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseInOut) {
                                   circleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                   circleView.backgroundColor = .init(named: "accent" )
                               }
            } else {
                UIView.animate(withDuration: 0.3) {
                    circleView.transform = .identity
                    circleView.backgroundColor = .init(named: "bgLight")
                }
            }
        }
    }
    
    // Updates the pin prompt with a new value
    func updatePinPrompt(with value: String) {
        pinPromptLabel.text = value
    }
}
