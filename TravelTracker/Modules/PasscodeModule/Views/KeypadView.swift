//
//  Created by Алексей on 16.11.2024.
//

import UIKit
import SnapKit


extension PasscodeView {
    
    final class KeypadView: UIView {
        
        private var keypadButtons: [UIButton] = []
        private lazy var handlers = Self.Handlers()
        
        private lazy var digitsView: GridView = {
            return GridView(rows: 4, cols: 3) { [weak self] in
                self?.createButton(for: $0) ?? UIView()
            }
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupSubviews()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupSubviews()
        }
        
        func configure(with model: PasscodeModel) {
            updateButtons(with: model)
        }
    }
}

extension PasscodeView.KeypadView {
    
    struct Handlers {
        var digitTap: Handler<Int>?
        var backspaceTap: Action?
        var cancelTap: Action?
    }
}

private extension PasscodeView.KeypadView {

    private func setupSubviews() {
        addSubview(digitsView)
        setupConstraints()
        digitsView.setupSubviews()
    }
    
    private func setupConstraints() {
        digitsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func createButton(for index: Int) -> UIButton? {
        guard index != 9 else  { return nil }
        let button = UIButton()
        button.tag = index != 10 ? index + 1 : 0

        switch index {
        case 11:
            button.setTitle("⌫", for: .normal)
            button.addAction(UIAction { [weak self] _ in self?.handlers.backspaceTap?() }, for: .touchUpInside)
            
        default:
            button.setTitle(String(button.tag), for: .normal)
            button.addAction(UIAction { [weak self] _ in self?.handlers.digitTap?(button.tag) }, for: .touchUpInside)
        }
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.init(named: "bgLight"), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        keypadButtons.append(button)

        return button
    }
    
    func updateButtons(with model: PasscodeModel) {
        keypadButtons.forEach { button in
            button.isEnabled = model.state == .normal
            
            switch button.tag {
            case 12:
                button.isEnabled = button.isEnabled && model.canRemoveDigit
                handlers.backspaceTap = handlers.backspaceTap ?? model.handlers.backspaceTap

            default:
                handlers.digitTap = handlers.digitTap ?? model.handlers.digitTap
            }
        }
    }
}



