//
//  Created by Алексей on 16.11.2024.
//

import UIKit

//MARK: - PasscodeViewControllerProtocol

protocol PasscodeViewControllerProtocol: AnyObject {
    func configure(with model: PasscodeModel)
}

//MARK: - PasscodeEntryViewController

final class PasscodeViewController: UIViewController {
    
    private let presenter: PresenterProtocol
    private let customView: PasscodeEntryViewProtocol
    
    init(presenter: PresenterProtocol, customView: PasscodeEntryViewProtocol) {
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

extension PasscodeViewController: PasscodeViewControllerProtocol {
    
    func configure(with model: PasscodeModel) {
        customView.configure(with: model)
    }
}

