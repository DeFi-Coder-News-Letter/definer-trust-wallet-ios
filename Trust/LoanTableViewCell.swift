// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class LoanTableViewCell: UITableViewCell {

    @IBOutlet weak var loanCreatedOn: UILabel!
    @IBOutlet weak var loanStatus: UILabel!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var loanType: UILabel!
    @IBOutlet weak var loanName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
