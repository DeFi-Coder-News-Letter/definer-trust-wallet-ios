// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class WalletTokenViewCell: UITableViewCell {

    @IBOutlet weak var tokenBalance: UILabel!
    @IBOutlet weak var tokenPercentage: UILabel!
    @IBOutlet weak var tokenSymbol: UILabel!
    @IBOutlet weak var tokenLogoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
