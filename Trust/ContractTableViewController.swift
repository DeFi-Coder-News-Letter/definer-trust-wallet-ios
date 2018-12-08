// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class ContractTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var navigationHeaderView: UIView!
    @IBOutlet weak var contractTableView: UITableView!
    var contracts = [ResourceData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            contractTableView.refreshControl = refreshControl
        } else {
            contractTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
        
        self.contractTableView.dataSource = self
        self.contractTableView.delegate = self
        self.navigationHeaderView.tintColor = UIColor(red:0.00, green:0.63, blue:0.91, alpha:1.0)
        self.navigationHeaderView.backgroundColor = UIColor(red:0.00, green:0.63, blue:0.91, alpha:1.0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.fetchData()
    }
    
    @objc private func refreshTableData(_ sender: Any) {
        self.fetchData()
        self.contractTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func fetchData() {
        DefinerApi().getContracts()
            .done { contractClass -> Void in
                //Do something with the JSON info
                self.contracts = contractClass.data!
                self.contractTableView.reloadData()
            }
            .catch { error in
                //Handle error or give feedback to the user
                print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contracts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractTableViewCell", for: indexPath) as! ContractTableViewCell

        let contractSummary = self.contracts[indexPath.row]
        let contract = contractSummary.data

        let dateFormatter = DateFormatter()
        // 2018-12-04 11:56:58.136374
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringParts = contractSummary.createTime!.components(separatedBy: ".")
        let date = dateFormatter.date(from: dateStringParts[0])

        // Configure the cell...
        cell.contractName.text = contract?.name
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        cell.createdOn.text = dateFormatter.string(from: date!)
        cell.contractType.text = self.getTypeString(typeStr: (contract?.contractType)!, tokenLabel: (contract?.tokenLabel)!, fundLabel: (contract?.fundLabel)!)
        cell.loanAmount.text = String(format:"%.2f", (contract?.borrowAmount)!) + " " + (contract?.fundLabel)!
        if contract?.loanType == "Borrower Initiated" {
            let yourImage: UIImage = UIImage(named: "Listing_Borrow")!
            cell.columnImage.image = yourImage
        } else {
            let yourImage: UIImage = UIImage(named: "Listing_Lend")!
            cell.columnImage.image = yourImage
        }
        cell.contractStatus.text = self.getStatusString(statusCode: (contract?.currentState)!)

        return cell
    }

    func getTypeString(typeStr : String, tokenLabel: String, fundLabel: String) -> String {
        switch typeStr {
        case "T2E":
            return tokenLabel + " to Eth"
        case "E2T":
            return "Eth to " + fundLabel
        case "T2T":
            return tokenLabel + " to " + fundLabel
        default:
            return "Unknown"
        }
    }
    
    func getStatusString(statusCode: Int) -> String {
        switch statusCode {
        case -1:
            return "Drafted"
        case 0:
            return "Init"
        case 1:
            return "Waiting For Lender"
        case 2:
            return "Waiting For Borrower"
        case 3:
            return "Waiting For Tokens"
        case 4:
            return "Funded"
        case 5:
            return "Finished"
        case 6:
            return "Closed"
        case 7:
            return "Default"
        default:
            return "Unknown"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        let contractSummary = self.contracts[indexPath.row]
        let contract = contractSummary.data
        let url = URL(string: "https://app.definer.org/main/loan/" + contract!.loanId!)!
        //UIApplication.shared.openURL(url)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.coordinator.inCoordinator?.showTab(.browser(openURL: url))
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
