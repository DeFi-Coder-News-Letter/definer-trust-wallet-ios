// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class LoanListViewController: UIViewController {

    @IBOutlet weak var lendButton: UIButton!
    @IBOutlet weak var borrowButton: UIButton!
    @IBOutlet weak var contextMenuView: UIView!
    @IBOutlet weak var mainMenuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeContextMenu()
        closeMainMenu()
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

}
