// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class DashboardViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var feedsTableView: UITableView!
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var contextMenuView: UIView!
    @IBOutlet weak var lendButton: UIButton!
    @IBOutlet weak var borrowButton: UIButton!
    
    var articleList: [ArticleData] = []
    
    var tapBGGesture: UITapGestureRecognizer!
    
    @IBAction func onListButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showLoanList", sender: self)
    }
    
    @IBAction func onWalletButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showWallet", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        closeMainMenu()
        closeContextMenu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeContextMenu()
        closeMainMenu()
        // Do any additional setup after loading the view.
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(settingsBGTapped))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapBGGesture)
        
        self.fetchData()
    }
    @objc fileprivate func settingsBGTapped(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            if !mainMenuView.isHidden && !mainMenuView.bounds.contains(sender.location(in: mainMenuView)) {
                self.closeMainMenu()
            }
            if !contextMenuView.isHidden && !contextMenuView.bounds.contains(sender.location(in: contextMenuView)) {
                self.closeContextMenu()
            }
        }
    }
    @IBAction func onCreateLoanMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.contextMenuView.transform == .identity {
                self.closeContextMenu()
            } else {
                self.contextMenuView.transform = .identity
            }
        })
        UIView.animate(withDuration: 0.8, delay:0.2, usingSpringWithDamping: 0.3, initialSpringVelocity:0, options: [], animations: {
            if self.contextMenuView.transform == .identity {
                self.borrowButton.transform = .identity
                self.lendButton.transform = .identity
            }
        })
    }
    func closeContextMenu() {
        contextMenuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.borrowButton.transform = CGAffineTransform(translationX: 0, y:15)
        self.lendButton.transform = CGAffineTransform(translationX: 11, y: 11)
    }
    func closeMainMenu() {
        self.mainMenuView.isHidden = true
    }
    @IBAction func onMainMenu(_ sender: Any) {
        self.mainMenuView.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchData() {
        DefinerApi().getArticles()
            .done { articles -> Void in
                //Do something with the JSON info
                self.articleList = articles.data!
                self.feedsTableView.reloadData()
            }
            .catch { error in
                //Handle error or give feedback to the user
                print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleList.count > 3 ? 3 : self.articleList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedsTableCell", for: indexPath) as! UITableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        bgColorView.layer.cornerRadius = 3
        cell.selectedBackgroundView = bgColorView
        cell.textLabel!.text = self.articleList[indexPath.row].content
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
