// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class LoanTableViewCell: UITableViewCell {

    @IBOutlet weak var loanCreatedOn: UILabel!
    @IBOutlet weak var loanStatus: UILabel!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var loanType: UILabel!
    @IBOutlet weak var loanName: UILabel!
    
    // Loan Detail View elements
    // TODO make it dynamically as list
    @IBOutlet weak var loanDetailLabel1: UILabel!
    @IBOutlet weak var loanDetailLabel2: UILabel!
    @IBOutlet weak var loanDetailLabel3: UILabel!
    @IBOutlet weak var loanDetailLabel4: UILabel!
    @IBOutlet weak var loanDetailLabel5: UILabel!
    @IBOutlet weak var loanDetailLabel6: UILabel!
    @IBOutlet weak var loanDetailLabel7: UILabel!
    @IBOutlet weak var loanDetailLabel8: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
