//
//  Created by Алексей on 23.09.2024.
//

import UIKit

//MARK: - PinEntryViewControllerProtocol

protocol PinCodeViewControllerProtocol: AnyObject {
    func configure(with model: PinCodeModel)
}

//MARK: - PinEntryViewController

final class PinCodeViewController: UIViewController {
    
    private let viewModel: PinCodeViewModelProtocol
    private lazy var customView = PinCodeView()
    
    init(viewModel: PinCodeViewModelProtocol) {
        self.viewModel = viewModel
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
        viewModel.viewDidLoad()
    }
}

//MARK: - PinEntryViewControllerProtocol Implementation

extension PinCodeViewController: PinCodeViewControllerProtocol {
    func configure(with model: PinCodeModel) {
        customView.configure(with: model)
    }
}
