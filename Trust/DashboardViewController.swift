// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class DashboardViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var contextMenuView: UIView!
    @IBOutlet weak var lendButton: UIButton!
    @IBOutlet weak var borrowButton: UIButton!
    var tapBGGesture: UITapGestureRecognizer!
    
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

}
