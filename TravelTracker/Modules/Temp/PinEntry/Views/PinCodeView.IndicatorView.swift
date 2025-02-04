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
        if dotSubviews.isEmpty {
            setupSubviews(for: model)
        }
        handleState(for: model)
    }
    
  
    func enqueueAnimation(_ animations: @escaping Action, completion: Action? = nil) {
        animationQueue.append((animations: animations, completion: completion))
        if !animationQueue.isEmpty {
            runNextAnimation()
        }
    }
}

//MARK: - PinCodeView.IndicatorView Private Methods

private extension PinCodeView.IndicatorView {
    
    func runNextAnimation() {
        guard let currentAnimation = animationQueue.first else { return }
        
        UIView.animate(
            withDuration: Configuration.subviewAnimationTime,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: currentAnimation.animations,
            completion: { [weak self] _ in
                currentAnimation.completion?()
                self?.animationQueue.removeFirst()
                self?.runNextAnimation()
            }
        )
    }
    
    func AnimateClearPinEffect(for model: PinCodeModel.IndicatorView) {
        enqueueAnimation {
            self.dotSubviews.forEach { subview in
                subview.transform = .identity
                subview.backgroundColor = UIColor(named: "bgLight")
            }
        }
    }
    
    func AnimateWrongPinEffect(for model: PinCodeModel.IndicatorView) {
        //let shakeDuration = 0.1
        let shakeOffset: CGFloat = 10

        enqueueAnimation({
            self.transform = CGAffineTransform(translationX: -shakeOffset, y: 0)
        })
        
        enqueueAnimation({
            self.transform = CGAffineTransform(translationX: shakeOffset, y: 0)
        })
        
        enqueueAnimation({
            self.transform = CGAffineTransform(translationX: -shakeOffset, y: 0)
        }, completion: {

            self.enqueueAnimation({
                self.transform = .identity
                self.AnimateClearPinEffect(for: model)
            })
        })
    }
    
    func setupSubviews(for model: PinCodeModel.IndicatorView) {
        (0..<model.pinCodeLength).forEach { _ in
            let view = UIView()
            view.layer.cornerRadius = Configuration.subviewSize / 2
            view.backgroundColor = .init(named: "bgLight")
            
            addArrangedSubview(view)
            dotSubviews.append(view)
            
            view.snp.makeConstraints {
                $0.width.height.equalTo(Configuration.subviewSize)
            }
        }
    }
    
    func handleState(for model: PinCodeModel.IndicatorView) {
        switch model.state {
        case .none:
            print(".normal started")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print(".normal completed")
                //model.onAnimationComplete?()
            }
        case .clearPin:
            print(".clearPin started")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print(".clearPin completed")
                //model.onAnimationComplete?()
            }
        case .wrongPin:
            print(".wrongPin started")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print(".wrongPin completed")
                //model.onAnimationComplete?()
            }
        case .some(.setupPin):
            return
        }
    }
    
        
    func AnimateNormalEffect(for model: PinCodeModel.IndicatorView) {
        dotSubviews.enumerated().forEach { index, subview in
            let isCurrentActive = index < model.pinCode.count
            let isPreviousActive = index < model.previousPinCode.count
            
            if index >= model.pinCode.count {
                subview.backgroundColor = UIColor(named: "bgLight")
            }
            
            guard isCurrentActive != isPreviousActive else { return }
            
            if isCurrentActive {
                subview.backgroundColor = UIColor(named: "accent")
                performAnimation {
                    let scale = Configuration.subvviewSizeMultiplier
                    subview.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            } else {
                subview.transform = .identity
                subview.backgroundColor = UIColor(named: "bgLight")
            }
        }
    }
        
    func performAnimation(_ animations: @escaping Action, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: Configuration.subviewAnimationTime,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: animations,
            completion: completion)
    }
}

