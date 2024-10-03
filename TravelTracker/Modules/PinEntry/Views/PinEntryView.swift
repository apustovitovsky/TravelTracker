//
//  Created by Алексей on 23.09.2024.
//

import UIKit
import SnapKit

//MARK: - PinEntryViewProtocol

protocol PinEntryViewProtocol: AnyObject {
    func configure(with model: PinEntryModel)
}

//MARK: - PinEntryView

final class PinEntryView: UIView {
    
    private enum Dimensions {
        static let verticalOffset: CGFloat = 64
        static let promptToIndicatorOffset: CGFloat = 32
        static let bottomInset: CGFloat = 48
    }
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var indicatorView = {
        PinEntryIndicatorView()
    }()
    
    private lazy var keypadView = {
        PinEntryKeypadView()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
}

//MARK: - PinEntryViewProtocol Implementation

extension PinEntryView: PinEntryViewProtocol {
    
    func configure(with model: PinEntryModel) {
        configurePromptLabel(with: model)
        indicatorView.configure(with: model)
        keypadView.configure(with: model)
    }
}

//MARK: - PinEntryView Private Methods

private extension PinEntryView {
    
    func configureLayout() {
        backgroundColor = .init(named: "bg")
        
        addSubview(hintLabel)
        addSubview(indicatorView)
        addSubview(keypadView)
        
        hintLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(Dimensions.verticalOffset)
            $0.centerX.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(hintLabel.snp.bottom).offset(Dimensions.promptToIndicatorOffset)
            $0.centerX.equalToSuperview()
        }
        
        keypadView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Dimensions.bottomInset)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configurePromptLabel(with model: PinEntryModel) {
        hintLabel.text = model.title
    }
}
