//
//  Created by Алексей on 23.09.2024.
//

import UIKit
import SnapKit

//MARK: - HomeViewProtocol

protocol PinEntryViewProtocol: AnyObject {
    func configure(with model: PinEntryModel)
}

//MARK: - HomeView

final class PinEntryView: UIView {
    
    private enum Dimensions {
        static let circleSize: CGFloat = 16
        static let buttonSize: CGFloat = 56
        static let circleSpacing: CGFloat = 24
        static let buttonSpacing: CGFloat = 42
        static let verticalOffset: CGFloat = 64
        static let promptToCirclesOffset: CGFloat = 32
        static let bottomInset: CGFloat = 48
    }
    
    //MARK: - pinPromptLabel
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - pinCirclesStackView
    
    private lazy var circlesView: PinEntryIndicatorView = {
        let stackView = PinEntryIndicatorView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = Dimensions.circleSpacing
        return stackView
    }()
    
    //MARK: - pinKeyboardStackView
    
    private lazy var KeypadView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = Dimensions.buttonSpacing
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

}

//MARK: - HomeView Extension

extension PinEntryView: PinEntryViewProtocol {
    
    func configure(with model: PinEntryModel) {
        setupPromptLabel(with: model)
        circlesView.configure(with: model)
        setupKeypad(with: model)
    }
}

private extension PinEntryView {
    
    //MARK: - setupLayout
    
    func setupLayout() {
        backgroundColor = .init(named: "bg")
        
        addSubview(hintLabel)
        addSubview(circlesView)
        addSubview(KeypadView)
        
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Dimensions.verticalOffset)
            make.centerX.equalToSuperview()
        }
        
        circlesView.snp.makeConstraints { make in
            make.top.equalTo(hintLabel.snp.bottom).offset(Dimensions.promptToCirclesOffset)
            make.centerX.equalToSuperview()
        }
        
        KeypadView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Dimensions.bottomInset)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - setupPromptLabel
    
    func setupPromptLabel(with model: PinEntryModel) {
        hintLabel.text = model.title
    }
    
    // MARK: - setupPinKeyboard
    
    func setupKeypad(with model: PinEntryModel) {
        KeypadView.subviews.forEach { $0.removeFromSuperview() }
        
        let buttons = model.buttons
        for i in stride(from: 0, to: buttons.count, by: 3) {
            let chunk = Array(buttons[i..<min(i + 3, buttons.count)])
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.distribution = .equalCentering
            rowView.spacing = Dimensions.buttonSpacing
            
            chunk.forEach { button in
                let button = createButton(with: button) { action in
                    model.handler?(action)
                }
                rowView.addArrangedSubview(button)
            }
            KeypadView.addArrangedSubview(rowView)
        }
    }
    
    // Creates an individual button for the pin keyboard
    private func createButton(with model: PinEntryModel.Button, handler: @escaping Handler<PinEntryModel.Action>) -> UIButton {
        let button = UIButton(type: .system)
        button.isEnabled = model.state != .disabled
        button.setTitle(model.title, for: .normal)
        button.layer.cornerRadius = Dimensions.buttonSize / 2
        button.setTitleColor(.init(named: "bgLight"), for: .disabled)
        button.setTitleColor(.white, for: .normal)
        
        if let _ = Int(model.title) {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40) //32
        }

        if let action = model.actionType {
            button.addAction(UIAction{ _ in handler(action) }, for: .touchUpInside)
        }

        button.snp.makeConstraints { make in
            make.width.height.equalTo(Dimensions.buttonSize)
        }
        
        return button
    }
}
