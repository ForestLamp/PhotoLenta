//
//  MainTabVC.swift
//  PhotoLenta
//
//  Created by Alex Ch. on 18.06.2021.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        tabBar.tintColor = .black
        let feed = createNavController(viewController: FeedController(), title: "Feed", selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"))
        let profile = createNavController(viewController: UIViewController(), title: "Profile", selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"))
        
        viewControllers = [feed, profile]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, selectedImage: UIImage, unselectedImage: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        viewController.navigationItem.title = title
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        viewController.view.backgroundColor = .white
        return navController
    }
    
}
