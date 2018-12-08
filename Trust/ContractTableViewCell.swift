// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class ContractTableViewCell: UITableViewCell {

    @IBOutlet weak var contractStatus: UILabel!
    @IBOutlet weak var columnImage: UIImageView!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var contractType: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var contractName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
