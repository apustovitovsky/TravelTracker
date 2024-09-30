//
//  Created by Алексей on 22.09.2024.
//

import UIKit
import RouteComposer

// MARK: - DefaultVC

class DefaultVC: UIViewController, ContextHolder {

    let context: ScreenDefinition
    
    let labelView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textColor = .systemYellow
        return label
    }()
    
    private let userButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    init(context: ScreenDefinition) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
        labelView.text = context.rawValue
        self.title = context.rawValue
        view.backgroundColor = .init(named: "bg")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        view.addSubview(labelView)
        view.addSubview(userButton)
        
        labelView.translatesAutoresizingMaskIntoConstraints = false
        userButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        ])
        
        userButton.addTarget(self, action: #selector(goUserTapped), for: .touchUpInside)
    }
    
    @objc func goUserTapped() {

    }
}



