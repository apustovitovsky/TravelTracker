//
//  Created by Алексей on 30.09.2024.
//

import UIKit
import SnapKit

//MARK: - PinEntryKeypadViewProtocol

protocol PinEntryKeypadViewProtocol: AnyObject {
    func configure(with model: PinEntryModel)
}

//MARK: - PinEntryKeypadView

final class PinEntryKeypadView: UIStackView {
    
    private enum Configuration {
        static let buttonSpacing: CGFloat = 42
        static let buttonSize: CGFloat = 56
        static let buttonTitleFontSize: CGFloat = 40
    }
    
    private var keypadButtons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
}

extension PinEntryKeypadView: PinEntryKeypadViewProtocol {
    
    func configure(with model: PinEntryModel) {
        configureKeypad(with: model)
    }
}

private extension PinEntryKeypadView {
    
    func configureView() {
        axis = .vertical
        distribution = .equalCentering
        spacing = Configuration.buttonSpacing
    }
    
    func configureKeypad(with model: PinEntryModel) {
        if keypadButtons.isEmpty {
            createKeypad(with: model)
        }
        updateKeypad(with: model)
    }
    
    func createKeypad(with model: PinEntryModel) {
        let buttons = model.keypadView.buttons
        stride(from: 0, to: buttons.count, by: 3).forEach { index in
            let chunk = Array(buttons[index..<min(index + 3, buttons.count)])
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalCentering
            stackView.spacing = Configuration.buttonSpacing
                
            chunk.forEach { buttonModel in
                let button = createButton()
                stackView.addArrangedSubview(button)
                keypadButtons.append(button)
            }
            addArrangedSubview(stackView)
        }
    }
    
    //MARK: - Update keypad buttons based on the model
    
    func updateKeypad(with model: PinEntryModel) {
        let isKeypadEnabled = model.keypadView.isEnabled
        
        zip(keypadButtons, model.keypadView.buttons).forEach { button, buttonModel in
            button.setTitle(buttonModel.title, for: .normal)
            
            // Enable or disable the button based on its state and the keypad state
            button.isEnabled = buttonModel.isEnabled && isKeypadEnabled
            
            // Add a new action if the button model has one
            button.removeTarget(nil, action: nil, for: .allEvents)
            if let action = buttonModel.action {
                button.addAction(UIAction { _ in model.keypadView.handler?(action) }, for: .touchUpInside)
            }
        }
    }

    //MARK: - Create button and setup the attributes
    
    func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.init(named: "bgLight"), for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Configuration.buttonTitleFontSize)

        button.snp.makeConstraints {
            $0.width.height.equalTo(Configuration.buttonSize)
        }
        return button
    }
}

