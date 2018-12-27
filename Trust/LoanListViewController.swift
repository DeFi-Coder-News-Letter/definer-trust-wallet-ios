// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class LoanListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var contractTableView: UITableView!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var mainMenuView: UIView!
    var contracts = [ResourceData]()
    var cellExpanded = false
    var expandedRow = 0
    var lastExpandedRow = 0

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
        
        
        contractTableView.delegate = self
        contractTableView.dataSource = self
        contractTableView.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
        closeContextMenu()
        closeMainMenu()
        categorySegmentControl.tintColor = UIColor.black
        //categorySegmentControl.backgroundColor = UIColor.red
        categorySegmentControl.setBackgroundImage(UIImage(named: "retangle_with_underline_normal"), for: .normal , barMetrics: .default)
        categorySegmentControl.setBackgroundImage(UIImage(named: "retangle_with_underline_selected"), for: .selected , barMetrics: .default)
        let selectedAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
        ]
        let normalAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
        ]
        categorySegmentControl.setTitleTextAttributes(normalAttributes, for: .normal)
        categorySegmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        self.fetchData()
    }
    func closeContextMenu() {
    }
    func closeMainMenu() {
    }
    @IBAction func onMainMenu(_ sender: Any) {
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func getLocalTimeString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        
        // "2018-12-08 20:29:18.849535"
        //dateFormatter.dateFormat = "yyyy-M-dd HH:mm:ss.SSSSSS"
        
        // "2018-12-08 20:29:18"
        dateFormatter.dateFormat = "yyyy-M-dd HH:mm:ss"
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateObj = dateFormatter.date(from: dateString)
        let date = dateObj
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSXXXXX"
        formatter.dateFormat = "MMM d, h:mm a"
        let currentDateTime = formatter.string(from: date!)
        return currentDateTime
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loanListCell", for: indexPath) as! LoanTableViewCell
        
        let contractSummary = self.contracts[indexPath.row]
        let contract = contractSummary.data
        // Configure the cell...
        cell.loanName.text = contract?.name
        cell.loanCreatedOn.text = getLocalTimeString(dateString: contractSummary.createTime!)
        cell.loanType.text = self.getTypeString(typeStr: (contract?.contractType)!, tokenLabel: (contract?.tokenLabel)!, fundLabel: (contract?.fundLabel)!)
        cell.loanAmount.text = String(format:"%.2f", (contract?.borrowAmount)!) + " " + (contract?.fundLabel)!
//        if contract?.loanType == "Borrower Initiated" {
//            let yourImage: UIImage = UIImage(named: "Listing_Borrow")!
//            cell.columnImage.image = yourImage
//        } else {
//            let yourImage: UIImage = UIImage(named: "Listing_Lend")!
//            cell.columnImage.image = yourImage
//        }
        cell.loanStatus.text = self.getStatusString(statusCode: (contract?.currentState)!)
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
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.coordinator.inCoordinator?.showTab(.browser(openURL: url))
        if cellExpanded {
            if indexPath.row == expandedRow {
                //collapse current already expanded row
                cellExpanded = false
            }
        } else {
            cellExpanded = true
        }
        expandedRow = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == expandedRow {
            if cellExpanded {
                return 250
            } else {
                return 20
            }
        }
        return 20
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
