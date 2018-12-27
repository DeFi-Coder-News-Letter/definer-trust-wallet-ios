// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class LoanListViewController: UIViewController {

    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var mainMenuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
