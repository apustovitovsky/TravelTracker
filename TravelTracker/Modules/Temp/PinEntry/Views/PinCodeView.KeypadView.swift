//
//  Created by Алексей on 30.09.2024.
//

import UIKit
import SnapKit


// MARK: - PinCodeView.KeypadView

extension PinCodeView.KeypadView {
    
    func configureView() {
        axis = .vertical
        distribution = .equalCentering
        spacing = Configuration.buttonSpacing
    }
    
    func configureKeypad(with model: PinCodeModel.KeypadView) {
        if keypadButtons.isEmpty {
            setupKeypad(with: model)
        }
        updateKeypad(with: model)
    }
}

// MARK: - PinCodeView.KeypadView Private Methods

private extension PinCodeView.KeypadView {
    
    private func setupKeypad(with model: PinCodeModel.KeypadView) {
        let buttons = model.buttons
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
    
    private func updateKeypad(with model: PinCodeModel.KeypadView) {
        
        zip(keypadButtons, model.buttons).forEach { button, buttonModel in
            button.setTitle(buttonModel.title, for: .normal)
            
            // Enable or disable the button based on its state and the keypad state
            button.isEnabled = buttonModel.state != .disabled && model.state != .disabled
            
            // Add a new action if the button model has one
            button.removeTarget(nil, action: nil, for: .allEvents)
            if let action = buttonModel.action {
                button.addAction(UIAction { _ in model.handler?(action) }, for: .touchUpInside)
            }
        }
    }

    //MARK: - Create button and setup the attributes
    
    private func createButton() -> UIButton {
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

