//
//  Created by Алексей on 23.09.2024.
//

import UIKit
import SnapKit

//MARK: - PinEntryViewProtocol

protocol PinCodeViewProtocol: AnyObject {
    func configure(with model: PinCodeModel)
}

//MARK: - PinEntryView

final class PinCodeView: UIView {
    
    private enum Dimensions {
        static let verticalOffset: CGFloat = 64
        static let promptToIndicatorOffset: CGFloat = 32
        static let bottomInset: CGFloat = 48
    }
    
    private lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var indicatorView = {
        IndicatorView()
    }()
    
    private lazy var keypadView = {
        KeypadView()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

//MARK: - PinEntryViewProtocol Implementation

extension PinCodeView: PinCodeViewProtocol {
    
    func configure(with model: PinCodeModel) {
        updatePromptLabel(model.promptLabel.text)
        indicatorView.configureSubviews(with: model.indicatorView)
        keypadView.configureKeypad(with: model.keypadView)
    }
}

extension PinCodeView {
    
    // MARK: - PinCodeView.IndicatorView
    
    final class IndicatorView: UIStackView {
        
        enum Configuration {
            static let subviewSpacing: CGFloat = 20
            static let subviewSize: CGFloat = 16
            static let subvviewSizeMultiplier: CGFloat = 1.3
            static let subviewAnimationTime: CGFloat = 0.2
        }
        
        var dotSubviews: [UIView] = []
        var animationQueue: [(animations: Action, completion: Action?)] = []
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configureView()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: - PinCodeView.KeypadView
    
    final class KeypadView: UIStackView {
        
        enum Configuration {
            static let buttonSpacing: CGFloat = 42
            static let buttonSize: CGFloat = 56
            static let buttonTitleFontSize: CGFloat = 40
        }
        
        var keypadButtons: [UIButton] = []
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configureView()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

//MARK: - PinCodeView Private Methods

private extension PinCodeView {
    
    func setupLayout() {
        backgroundColor = .init(named: "bg")
        
        addSubview(promptLabel)
        addSubview(indicatorView)
        addSubview(keypadView)
        
        promptLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(Dimensions.verticalOffset)
            $0.centerX.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(promptLabel.snp.bottom).offset(Dimensions.promptToIndicatorOffset)
            $0.centerX.equalToSuperview()
        }
        
        keypadView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Dimensions.bottomInset)
            $0.centerX.equalToSuperview()
        }
    }
    
    func updatePromptLabel(_ title: String?) {
        promptLabel.text = title
    }
}
