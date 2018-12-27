// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class DefinerWalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tokenListCell", for: indexPath) as! WalletTokenViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        bgColorView.layer.cornerRadius = 3
        cell.selectedBackgroundView = bgColorView
        
        // TODO now we have only ethereum and FIN.
        if indexPath.row == 0 {
            cell.tokenLogoImage.image = UIImage(named: "ethereum-filled-500")
            cell.tokenSymbol.text = "Ethereum (ETH)"
            cell.tokenPercentage.text = "80%"
            cell.tokenBalance.text = String(format: "%.2f", 10.23)
        } else if indexPath.row == 1 {
            cell.tokenLogoImage.image = UIImage(named: "shark-filled-100")
            cell.tokenSymbol.text = "FIN (FIN)"
            cell.tokenPercentage.text = "20%"
            cell.tokenBalance.text = String(format: "%.2f", 257.23)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
