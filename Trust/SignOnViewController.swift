// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import RealmSwift

class SignOnViewController: UIViewController {
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
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)
        if keystore.hasWallets {
            let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first!
            self.GreetingInfoLabel.text = String(wallet.description)
        } else {
            self.GreetingInfoLabel.text = "Register with email to start"
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
