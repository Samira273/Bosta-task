//
//  SplashVC.swift
//  BostaTask
//
//  Created by Samira Marassy on 16/06/2022.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            AppManager.shared.setWindowRoot(VCsContainer.getProfileScene())
        }
    }

}
