// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class RegisterPopupViewController: UIViewController {

    @IBAction func OnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {});//This is intended to dismiss the Info sceen.
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
