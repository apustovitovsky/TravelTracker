//
//  Created by Алексей on 18.11.2024.
//

import UIKit

extension PasscodeView {
    
    final class PromptLabel: UILabel {

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with model: PasscodeModel) {
            text = model.title
        }
    }
}

private extension PasscodeView.PromptLabel {
    
    func setupView() {
        textColor = .white
        font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textAlignment = .center
    }
}

