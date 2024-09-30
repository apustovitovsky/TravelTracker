//
//  Created by Алексей on 29.09.2024.
//

import UIKit
import SnapKit

//MARK: - CircleView

protocol PinEntryIndicatorViewProtocol: AnyObject {
    func configure(with model: PinEntryModel)
}

final class PinEntryIndicatorView: UIStackView {
    
    private enum Dimensions {
        static let circleSize: CGFloat = 16
        static let circleSizeMultiplier: CGFloat = 1.3
    }
}

//MARK: - CircleViewProtocol Implementation

extension PinEntryIndicatorView: PinEntryIndicatorViewProtocol {
    
    func configure(with model: PinEntryModel) {
        setupDotViews(with: model)
    }
}

//MARK: - Private Methods

private extension PinEntryIndicatorView {
    
    func setupDotViews(with model: PinEntryModel) {
        subviews.forEach { $0.removeFromSuperview() }
        
        // Создаем кружки на основе количества символов для ввода PIN-кода
        for index in 0..<model.requiredPinLength {
            let pinCircleView = UIView()
            pinCircleView.layer.cornerRadius = Dimensions.circleSize / 2
            
            // Устанавливаем цвет фона в зависимости от того, активен ли кружок
            pinCircleView.backgroundColor = index < model.enteredPinDigits.count ? UIColor(named: "accent") : UIColor(named: "bgLight")
            
            addArrangedSubview(pinCircleView)

            pinCircleView.snp.makeConstraints { make in
                make.width.height.equalTo(Dimensions.circleSize)
            }
            
            // Если кружок активен, проверяем, нужно ли его анимировать
            if index < model.enteredPinDigits.count {
                if index >= model.previousPinDigits.count {
                    // Анимация для нового активного кружка
                    animatePinChange(pinCircleView, duration: 0.2)
                } else {
                    // Увеличение без анимации для уже активных кружков
                    animatePinChange(pinCircleView)
                }
            }
        }
    }
    
    // Анимация изменения состояния кружка
    func animatePinChange(_ pinCircleView: UIView, duration: Double? = nil) {
        // Если продолжительность не задана, просто увеличиваем кружок
        guard let duration = duration else {
            pinCircleView.transform = CGAffineTransform(scaleX: Dimensions.circleSizeMultiplier, y: Dimensions.circleSizeMultiplier)
            return
        }
        
        // Анимация для активных кружков с плавным изменением
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {
                pinCircleView.transform = CGAffineTransform(scaleX: Dimensions.circleSizeMultiplier, y: Dimensions.circleSizeMultiplier)
                pinCircleView.backgroundColor = UIColor(named: "accent")
            }
        )
    }
}
