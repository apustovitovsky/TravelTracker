//
//  Created by Алексей on 16.11.2024.
//

import UIKit
import SnapKit

extension PasscodeView {
    
    final class ProgressIndicatorView: UIStackView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        @available(*, unavailable)
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with model: PasscodeModel) {
            setupCircles(with: model)
        }
    }
}

private extension PasscodeView.ProgressIndicatorView {
    
    enum Constants {
        static let circleSpacing: CGFloat = 24
        static let circleSize: CGFloat = 16
        static let circleScaleFilled: CGFloat = 1.2
        static let snakeOffsets: [CGFloat] = [-12, 12, -8, 8, -2, 2, 0]
        static let animationDuration: TimeInterval = 0.2
        static let failureAnimationDuration: TimeInterval = 0.4
        static let resetInputDelay: TimeInterval = 0.4
    }
    
    func setupView() {
        axis = .horizontal
        distribution = .equalCentering
        spacing = Constants.circleSpacing
    }
    
    func setupCircles(with model: PasscodeModel) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let circleColorEmpty = UIColor(named: "bgLight")
        
        for index in 0..<model.passcodeLength {
            let circleView = UIView()
            circleView.layer.cornerRadius = Constants.circleSize / 2
            let circleColorFilled = model.progressIndicator.state == .failure ? UIColor(named: "error") : UIColor(named: "accent")
            
            addArrangedSubview(circleView)
            circleView.snp.makeConstraints { $0.width.height.equalTo(Constants.circleSize) }
            
            switch model.progressIndicator.indicatorStates[index] {
            case .filled:
                circleView.backgroundColor = circleColorFilled
                circleView.transform = CGAffineTransform(scaleX: Constants.circleScaleFilled, y: Constants.circleScaleFilled)
            case .toFill:
                circleView.backgroundColor = circleColorEmpty
                animateCircle(circleView, scale: Constants.circleScaleFilled, backgroundColor: circleColorFilled)
            case .toClear:
                circleView.backgroundColor = circleColorFilled
                circleView.transform = CGAffineTransform(scaleX: Constants.circleScaleFilled, y: Constants.circleScaleFilled)
                animateCircle(circleView, scale: 1, backgroundColor: circleColorEmpty)
            case .empty:
                circleView.backgroundColor = circleColorEmpty
            }
        }
        
        if model.state == .failure {
            animateIndicatorFailure()
        }
    }
    
    func animateIndicatorFailure() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = Constants.failureAnimationDuration
        animation.values = Constants.snakeOffsets
        animation.isRemovedOnCompletion = true
        layer.add(animation, forKey: "shake")
    }
    
    func animateCircle(_ circleView: UIView, scale: Double, backgroundColor: UIColor?) {
        
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.3,
            options: .curveEaseInOut,
            animations: {
                circleView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        )

        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                circleView.backgroundColor = backgroundColor
            }
        )
    }
}


