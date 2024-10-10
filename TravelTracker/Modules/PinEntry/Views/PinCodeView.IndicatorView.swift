//
//  Created by Алексей on 29.09.2024.
//

import UIKit
import SnapKit


//MARK: - PinCodeView.IndicatorView

extension PinCodeView.IndicatorView {
    
    func configureView() {
        axis = .horizontal
        distribution = .equalCentering
        spacing = Configuration.subviewSpacing
    }
    
    func configureSubviews(with model: PinCodeModel.IndicatorView) {
        if indicatorSubviews.isEmpty {
            setupSubviews(count: model.pinCodeLength)
        }
        playAnimation(for: model)
    }
}

//MARK: - PinCodeView.IndicatorView Private Methods

private extension PinCodeView.IndicatorView {
    
    func setupSubviews(count: Int) {
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
    
    func AnimateFailureEffect(for model: PinCodeModel.IndicatorView) {

        indicatorSubviews.forEach { view in
            view.backgroundColor = .red
            UIView.animate(
                withDuration: 2,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: .curveEaseOut) {

                view.transform = .identity
                }
        }

    }
    
    func AnimateLoadingEffect(for model: PinCodeModel.IndicatorView) {
        indicatorSubviews.forEach { view in
            UIView.animate(
                withDuration: 1,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: .curveEaseOut) {
                    let scale = Configuration.subvviewSizeMultiplier
                    view.transform = CGAffineTransform(scaleX: scale, y: scale)
                    view.backgroundColor = UIColor(named: "accent")
            }
        }

    }
    
    func playAnimation(for model: PinCodeModel.IndicatorView) {
        switch model.state {
        case .normal:
            AnimateNormalEffects(for: model)
        case .processingPin:
            AnimateLoadingEffect(for: model)
        case .wrongPin:
            AnimateFailureEffect(for: model)
        }
    }
        
    func AnimateNormalEffects(for model: PinCodeModel.IndicatorView) {
        indicatorSubviews.enumerated().forEach { index, view in
            let isCurrentActive = index < model.pinCode.count
            let isPreviousActive = index < model.previousPinCode.count
            
            if index >= model.pinCode.count {
                view.backgroundColor = UIColor(named: "bgLight")
            }
            
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

