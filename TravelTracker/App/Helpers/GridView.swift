import UIKit


class GridView: UIStackView {

    private var content: ((Int) -> UIView?)?
    private var rows: Int = 1
    private var cols: Int = 1

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    convenience init(rows: Int, cols: Int, content: @escaping (Int) -> UIView?) {
        self.init()
        self.rows = max(rows, self.rows)
        self.cols = max(cols, self.cols)
        self.content = content
    }
    
    private func setupView() {
        self.axis = .vertical
        self.spacing = 32
        self.distribution = .fillEqually
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupSubviews() {
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        (0..<rows).forEach { row in
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 48
            rowStack.distribution = self.distribution
            
            (0..<cols).forEach { col in
                let index = row * cols + col
                let view = content?(index) ?? UIView()
                rowStack.addArrangedSubview(view)
            }
            
            self.addArrangedSubview(rowStack)
        }
    }
}
