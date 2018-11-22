// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import RealmSwift
import TrustCore
import Alamofire

class SignUpViewController: UIViewController {

    let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var SignUpButton: SignUpButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadingIndicator.isHidden = true
    }
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var emailAddress: UITextField!

    @IBAction func OnSignUp(_ sender: Any) {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)
        if keystore.hasWallets {
            let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first!
            let accountAddress = EthereumAddress(data: wallet.currentAccount.address.data, coin: Coin.ethereum)?.eip55String
            self.makePostCallWithAlamofire(account : accountAddress!)
        }
    }
    func makePostCallWithAlamofire(account : String) {
        let parameters: [String: Any] = [
            "data" : [
                "email" : self.emailAddress.text as! String,
                "telegram" : "not used"
            ],
            "status" : "REQUESTED"
        ]

        Alamofire.request("https://app.definer.org/definer/api/v1.0/accounts/" + account.localizedLowercase, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                self.performSegue(withIdentifier: "ToWelcome", sender: self)
        }
    }
}
