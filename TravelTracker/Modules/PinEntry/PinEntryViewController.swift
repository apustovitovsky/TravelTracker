//
//  Created by Алексей on 23.09.2024.
//

import UIKit

//MARK: - PinEntryViewControllerProtocol

protocol PinEntryViewControllerProtocol: AnyObject {
    func configure(with model: PinEntryModel)
}

//MARK: - PinEntryViewController

final class PinEntryViewController: UIViewController {
    
    private let viewModel: PinEntryViewModelProtocol
    private lazy var customView = PinEntryView()
    
    init(viewModel: PinEntryViewModelProtocol) {
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

extension PinEntryViewController: PinEntryViewControllerProtocol {
    func configure(with model: PinEntryModel) {
        customView.configure(with: model)
    }
}
