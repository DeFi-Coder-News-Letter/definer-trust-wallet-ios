// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var contextMenuView: UIView!
    @IBOutlet weak var lendButton: UIButton!
    @IBOutlet weak var borrowButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeMenu()
    }
    @IBAction func onCreateLoanMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.contextMenuView.transform == .identity {
                self.closeMenu()
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
    func closeMenu() {
        contextMenuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.borrowButton.transform = CGAffineTransform(translationX: 0, y:15)
        self.lendButton.transform = CGAffineTransform(translationX: 11, y: 11)
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
