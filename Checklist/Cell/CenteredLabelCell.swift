
import UIKit

class CenteredLabelCell: UITableViewCell {
    
    // MARK: Private Outlets
    @IBOutlet private var label: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
        backgroundColor = .white
    }
    
    // MARK: Public
    func configure(with title: String) {
        label.text = title
    }
}
