// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import BigInt
import web3swift
import Foundation

class DefinerWalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do{
            try self.test()
        } catch {
            print("error")
        }
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
    
    func test() throws {
        // create normal keystore
        
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        guard let keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore") else { return }
        var ks: EthereumKeystoreV3?
        if (keystoreManager.addresses.isEmpty) {
            ks = try! EthereumKeystoreV3(password: "BANKEXFOUNDATION")
            let keydata = try! JSONEncoder().encode(ks!.keystoreParams)
            FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
        } else {
            ks = keystoreManager.walletForAddress((keystoreManager.addresses[0])) as? EthereumKeystoreV3
        }
        guard let sender = ks?.addresses.first else { return }
        print(sender)
        
        //create BIP32 keystore
        guard let bip32keystoreManager = KeystoreManager.managerForPath(userDir + "/bip32_keystore", scanForHDwallets: true) else { return }
        var bip32ks: BIP32Keystore!
        if (bip32keystoreManager.addresses.isEmpty) {
            let mnemonics = try Mnemonics("normal dune pole key case cradle unfold require tornado mercy hospital buyer")
            bip32ks = try BIP32Keystore(mnemonics: mnemonics, password: "BANKEXFOUNDATION")
            let keydata = try! JSONEncoder().encode(bip32ks!.keystoreParams)
            FileManager.default.createFile(atPath: userDir + "/bip32_keystore"+"/key.json", contents: keydata, attributes: nil)
        } else {
            bip32ks = bip32keystoreManager.walletForAddress((bip32keystoreManager.addresses[0])) as? BIP32Keystore
        }
        guard let bip32sender = bip32ks?.addresses.first else { return }
        print(bip32sender)
        
        
        // BKX TOKEN
        let web3Main = Web3(infura: .rinkeby)
        let coldWalletAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
        let constractAddress = Address("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
        let gasPrice = try web3Main.eth.getGasPrice()
        var options = Web3Options.default
        options.gasPrice = gasPrice
        options.from = Address("0xE6877A4d8806e9A9F12eB2e8561EA6c1db19978d")
        
        web3Main.keystoreManager = keystoreManager
        let contract = ERC20(constractAddress)
        let tokenName = try contract.name()
        print("BKX token name = \(tokenName)")
        let balance = try contract.balance(of: coldWalletAddress)
        print("BKX token balance = \(balance)")
        
        //Send on Rinkeby using normal keystore
        print("Rinkeby")
        Web3.default = Web3(infura: .rinkeby)
        let web3Rinkeby = Web3.default
        web3Rinkeby.keystoreManager = keystoreManager
        let coldWalletABI = "[{\"payable\":true,\"type\":\"fallback\"}]"
        options = Web3Options.default
        options.gasLimit = BigUInt(21000)
        options.from = ks?.addresses.first!
        options.value = BigUInt(1000000000000000)
        options.from = sender
        let estimatedGas = try web3Rinkeby.contract(coldWalletABI, at: coldWalletAddress).method(options: options).estimateGas(options: nil)
        options.gasLimit = estimatedGas
        var intermediateSend = try web3Rinkeby.contract(coldWalletABI, at: coldWalletAddress).method(options: options)
        let sendingResult = try intermediateSend.send(password: "BANKEXFOUNDATION")
        let txid = sendingResult.hash
        print("On Rinkeby TXid = " + txid)
        
        // Send ETH on Rinkeby using BIP32 keystore. Should fail due to insufficient balance
        web3Rinkeby.keystoreManager = bip32keystoreManager
        options.from = bip32ks?.addresses.first!
        intermediateSend = try web3Rinkeby.contract(coldWalletABI, at: coldWalletAddress).method(options: options)
        let transaction = try intermediateSend.send(password: "BANKEXFOUNDATION")
        print(transaction)
        
        //Send ERC20 token on Rinkeby
        web3Rinkeby.addKeystoreManager(keystoreManager)
        let testToken = ERC20("0xa407dd0cbc9f9d20cdbd557686625e586c85b20a")
        testToken.options.from = ks!.addresses.first!
        
        let transaction1 = try testToken.transfer(to: "0x6394b37Cf80A7358b38068f0CA4760ad49983a1B", amount: 1)
        print(transaction1)
        
        //Send ERC20 on Rinkeby using a convenience function
        let transaction2 = try testToken.approve(to: "0x6394b37Cf80A7358b38068f0CA4760ad49983a1B", amount: NaturalUnits("0.0001"))
        print(transaction2)
        
        //Balance on Rinkeby
        let rinkebyBalance = try web3Rinkeby.eth.getBalance(address: coldWalletAddress)
        print("Balance of \(coldWalletAddress.address) = \(rinkebyBalance)")
        
        let deployedTestAddress = Address("0x1e528b190b6acf2d7c044141df775c7a79d68eba")
        options = Web3Options.default
        options.gasLimit = BigUInt(100000)
        options.value = BigUInt(0)
        options.from = ks?.addresses[0]
        let transaction3 = try deployedTestAddress.send("increaseCounter(uint8)", 1, password: "BANKEXFOUNDATION").wait()
        print(transaction3)
    }
}
