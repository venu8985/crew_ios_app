//
//  MainTabbarViewController.swift
//  Crew
//
//  Created by Rajeev on 10/05/21.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.items![0].title = NSLocalizedString("Home", comment: "")
        self.tabBar.items![1].title = NSLocalizedString("Categories", comment: "")
        self.tabBar.items![2].title = NSLocalizedString("Search", comment: "")
        self.tabBar.items![3].title = NSLocalizedString("Projects", comment: "")
        self.tabBar.items![4].title = NSLocalizedString("Profile", comment: "")

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
