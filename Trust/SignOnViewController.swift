// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import RealmSwift
import TrustCore
import Alamofire

class SignOnViewController: UIViewController {
    @IBOutlet weak var RegisterButton: RegisterButton!
    @IBOutlet weak var grayLine: UIImageView!
    @IBOutlet weak var emailAddressInput: UITextField!
    @IBOutlet weak var accountStatusLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GreetingInfoLabel: UILabel!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var statusCheckTimer: Timer!
    @IBAction func OnRegister(_ sender: Any) {
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)
        if keystore.hasWallets {
            delegate.coordinator = AppCoordinator(window: delegate.window!, keystore: keystore, navigator: delegate.urlNavigatorCoordinator)
            delegate.coordinator.start()
        } else {
            self.performSegue(withIdentifier: "SignUpError", sender: self)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.green
        self.accountStatusLabel.isHidden = true
        self.emailAddressInput.isHidden = true
        self.grayLine.isHidden = true
        self.RegisterButton.isHidden = true
        
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)
        if keystore.hasWallets {
            let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first!
            
            let accountAddress = EthereumAddress(data: wallet.currentAccount.address.data, coin: Coin.ethereum)?.eip55String
            
            self.GreetingInfoLabel.text = "Loading account infomation..."
            
            self.statusCheckTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                self.makeGetCallWithAlamofire(account : accountAddress!)
            }
        } else {
            self.GreetingInfoLabel.text = "Register with email to start"
        }
    }

    func makeGetCallWithAlamofire(account : String) {
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
        //self.accountStatusLabel.isHidden = true
        
        let todoEndpoint: String = "https://app.definer.org/definer/api/v1.0/accounts/" + account.localizedLowercase
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on account")
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
                // get and print the title
                let accountStatus : String = json["status"] as! String
                let accountData = json["data"] as? [String: Any]
                guard let accountEmail = accountData!["email"] as? String else {
                    print("Could not get email from JSON")
                    return
                }
                print("The email is: " + accountEmail)
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.GreetingInfoLabel.text = "Welcome back " + accountEmail
                
                switch accountStatus.uppercased() {
                case "CONFIRMED":
                    self.accountStatusLabel.isHidden = true
                    self.RegisterButton.isEnabled = true
                    self.RegisterButton.setTitle("CONTINUE", for: UIControlState.normal)
                    self.RegisterButton.isHidden = false
                    self.statusCheckTimer.invalidate()
                case "VALIDATION_EMAIL_SENT":
                    self.accountStatusLabel.text = "Thank you for choosing DeFiner. An validation email was sent to you. Please validate in your email inbox."
                    self.accountStatusLabel.isHidden = false
                    self.RegisterButton.isEnabled = false
                    self.RegisterButton.setTitle("CONTINUE", for: UIControlState.normal)
                    self.RegisterButton.isHidden = true
                default:
                    self.RegisterButton.isEnabled = false
                    self.RegisterButton.setTitle("CONTINUE", for: UIControlState.disabled)
                    self.RegisterButton.isHidden = true
                }
                
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
