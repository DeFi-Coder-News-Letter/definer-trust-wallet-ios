// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import RealmSwift
import TrustCore
import Alamofire

class SignOnViewController: UIViewController {
    @IBOutlet weak var RegisterButton: RegisterButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GreetingInfoLabel: UILabel!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBAction func OnRegister(_ sender: Any) {
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)
        if keystore.hasWallets {
            self.performSegue(withIdentifier: "SignUpError", sender: self)
            return
        } else {
            delegate.coordinator = AppCoordinator(window: delegate.window!, keystore: keystore, navigator: delegate.urlNavigatorCoordinator)
            delegate.coordinator.start()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.green
        self.RegisterButton.isHidden = true
        self.loadingIndicator.startAnimating()
        
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)
        if keystore.hasWallets {
            let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first!
            
            let accountAddress = EthereumAddress(data: wallet.currentAccount.address.data, coin: Coin.ethereum)?.eip55String
            
            self.GreetingInfoLabel.text = accountAddress
            
            makeGetCallWithAlamofire()
        } else {
            self.GreetingInfoLabel.text = "Register with email to start"
        }
    }

    func makeGetCallWithAlamofire() {
        let todoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
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
                guard let todoTitle = json["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.RegisterButton.setTitle("CONTINUE", for: UIControlState.normal)
                self.RegisterButton.isHidden = false

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
