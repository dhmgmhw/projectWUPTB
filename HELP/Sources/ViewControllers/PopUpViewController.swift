//
//  PopUpViewController.swift
//  HELP
//
//  Created by Moon on 2021/10/21.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnSetTapped(_ sender: UIButton) {
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
