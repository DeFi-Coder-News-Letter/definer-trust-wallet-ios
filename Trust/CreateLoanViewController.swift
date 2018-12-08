// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class CreateLoanViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var menuArea: UIView!
    var tapBGGesture: UITapGestureRecognizer!

    @IBAction func OnLend(_ sender: Any) {
        let url = URL(string: "https://app.definer.org/main/create/lend")!
        //UIApplication.shared.openURL(url)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.coordinator.inCoordinator?.showTab(.browser(openURL: url))
        self.dismiss(animated: true)
    }
    
    @IBAction func OnBorrow(_ sender: Any) {
        let url = URL(string: "https://app.definer.org/main/create/borrow")!
        //UIApplication.shared.openURL(url)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.coordinator.inCoordinator?.showTab(.browser(openURL: url))
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(settingsBGTapped))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapBGGesture)
        
        menuArea.layer.cornerRadius = 10
        menuArea.layer.opacity = 1.0
        menuArea.layer.masksToBounds = false
        menuArea.layer.shadowOffset = CGSize(width: 1, height: 1)
        menuArea.layer.shadowRadius = 10
        menuArea.layer.shadowOpacity = 0.5
    }
    
    @objc fileprivate func settingsBGTapped(sender: UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.ended{
            if !menuArea.bounds.contains(sender.location(in: menuArea)) {
                    self.dismiss(animated: true, completion: { () -> Void in
                })
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func viewWillDisappear(animated: Bool) {
        self.view.removeGestureRecognizer(tapBGGesture)
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
