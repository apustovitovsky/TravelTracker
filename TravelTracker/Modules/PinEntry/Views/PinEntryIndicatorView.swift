//
//  Created by Алексей on 29.09.2024.
//

import UIKit
import SnapKit


//MARK: - PinEntryIndicatorViewProtocol

protocol PinEntryIndicatorViewProtocol: AnyObject {
    func configure(with model: PinEntryModel)
}

//MARK: - PinEntryIndicatorView

final class PinEntryIndicatorView: UIStackView {
    
    private enum Configuration {
        static let subviewSpacing: CGFloat = 20
        static let subviewSize: CGFloat = 16
        static let subvviewSizeMultiplier: CGFloat = 1.3
        static let subviewAnimationTime: CGFloat = 0.2
    }
    
    private var indicatorSubviews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
}

//MARK: - PinEntryIndicatorView Implementation

extension PinEntryIndicatorView: PinEntryIndicatorViewProtocol {
    
    func configure(with model: PinEntryModel) {
        configureSubviews(with: model)
    }
}

//MARK: - PinEntryIndicatorView Private Methods

private extension PinEntryIndicatorView {
    
    func configureView() {
        axis = .horizontal
        distribution = .equalCentering
        spacing = Configuration.subviewSpacing
    }
    
    func configureSubviews(with model: PinEntryModel) {
        if indicatorSubviews.isEmpty {
            createSubviews(count: model.requiredPinLength)
        }
        updateSubviews(for: model)
    }
    
    func createSubviews(count: Int) {
        (0..<count).forEach { _ in
            let view = UIView()
            view.layer.cornerRadius = Configuration.subviewSize / 2
            view.backgroundColor = .init(named: "bgLight")
            
            addArrangedSubview(view)
            indicatorSubviews.append(view)
            
            view.snp.makeConstraints {
                $0.width.height.equalTo(Configuration.subviewSize)
            }
        }
    }
    
    func AnimateFailureEffect() {
        indicatorSubviews.forEach { view in
            
                view.backgroundColor = .red
            
        }

    }
        
    func updateSubviews(for model: PinEntryModel) {
//        guard model.state == .normal else {
//            AnimateFailureEffect()
//            return
//        }
        indicatorSubviews.enumerated().forEach { index, view in
            let isCurrentActive = index < model.indicatorView.pinLengthTo
            let isPreviousActive = index < model.indicatorView.pinLengthFrom
            guard isCurrentActive != isPreviousActive else { return }
            
            if isCurrentActive {
                view.backgroundColor = UIColor(named: "accent")
                animateSubview {
                    let scale = Configuration.subvviewSizeMultiplier
                    view.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            } else {
                view.transform = .identity
                view.backgroundColor = UIColor(named: "bgLight")
            }
        }
    }
        
    func animateSubview(_ animation: @escaping Action) {
        UIView.animate(
            withDuration: Configuration.subviewAnimationTime,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: animation)
    }
}

