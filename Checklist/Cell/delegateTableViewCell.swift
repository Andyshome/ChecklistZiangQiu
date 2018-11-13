

import UIKit

class delegateTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLable: UILabel!
    @IBOutlet weak var detailLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
