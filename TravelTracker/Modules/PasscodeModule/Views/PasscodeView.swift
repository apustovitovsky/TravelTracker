//
//  Created by Алексей on 16.11.2024.
//

import UIKit
import SnapKit

//MARK: - PasscodeEntryViewProtocol

protocol PasscodeViewProtocol: UIView {
    func configure(with model: PasscodeModel)
}

//MARK: - PasscodeEntryView

final class PasscodeView: UIView {
    
    private lazy var promptLabel = PromptLabel()
    private lazy var progressIndicatorView = ProgressIndicatorView()
    private lazy var keypadView = KeypadView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

//MARK: - PasscodeEntryView Configurable

extension PasscodeView: PasscodeViewProtocol {

    func configure(with model: PasscodeModel) {
        promptLabel.configure(with: model)
        progressIndicatorView.configure(with: model)
        keypadView.configure(with: model)
    }
}


//MARK: - PasscodeEntryView Private Methods

private extension PasscodeView {
    
    enum Configuration {
        static let verticalOffset: CGFloat = 64
        static let promptToIndicatorOffset: CGFloat = 40
        static let bottomInset: CGFloat = 48
    }
    
    func setupView() {
        backgroundColor = .init(named: "bg")
    }
    
    func setupLayout() {
        addSubview(promptLabel)
        addSubview(progressIndicatorView)
        addSubview(keypadView)
        
        promptLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(Configuration.verticalOffset)
            $0.centerX.equalToSuperview()
        }
        
        progressIndicatorView.snp.makeConstraints {
            $0.top.equalTo(promptLabel.snp.bottom).offset(Configuration.promptToIndicatorOffset)
            $0.centerX.equalToSuperview()
        }
        
        keypadView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Configuration.bottomInset)
            $0.centerX.equalToSuperview()
        }
    }
}


