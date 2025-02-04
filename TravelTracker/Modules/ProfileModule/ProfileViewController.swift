//
//  Created by Алексей on 16.11.2024.
//

import UIKit


protocol ProfileViewControllerProtocol: AnyObject {
    func configure(with model: PasscodeModel)
}


final class ProfileViewController: UIViewController {
    
    private let presenter: PresenterProtocol
    private let customView: PasscodeViewProtocol
    
    init(presenter: PresenterProtocol, customView: PasscodeViewProtocol) {
        self.presenter = presenter
        self.customView = customView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

//MARK: - PasscodeEntryViewController Extension

extension ProfileViewController: PasscodeViewControllerProtocol {
    
    func configure(with model: PasscodeModel) {
        customView.configure(with: model)
    }
}

