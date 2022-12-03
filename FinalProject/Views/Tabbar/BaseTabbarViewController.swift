//
//  Tabbar.swift
//  FinalProject
//
//  Created by tu.le2 on 22/07/2022.
//

import Foundation
import UIKit

final class BaseTabbarViewController: UITabBarController {
    private static var sharedTabbarManager: BaseTabbarViewController = {
        let tabbarManager = BaseTabbarViewController()
        return tabbarManager
    }()

    class func shared() -> BaseTabbarViewController {
        return sharedTabbarManager
    }

    func createTabbar() {
        let homeVC = HomeViewController()
        if #available(iOS 13.0, *) {
            homeVC.tabBarItem = UITabBarItem(title: "Trang chủ", image: UIImage(systemName: "house.fill"), tag: 0)
        } else {
            // Fallback on earlier versions
        }
        let homeViewModel = HomeViewModel()
        homeVC.viewModel = homeViewModel
        let homeNavi = UINavigationController(rootViewController: homeVC)

        let exploreVC = ExploreViewController()
        if #available(iOS 13.0, *) {
            exploreVC.tabBarItem = UITabBarItem(title: "Khám phá", image: UIImage(systemName: "safari.fill"), tag: 1)
        } else {
            // Fallback on earlier versions
        }
        let exploreViewModel = ExploreViewModel(contentMoviesSlider: [])
        exploreVC.viewModel = exploreViewModel
        let exploreNavi = UINavigationController(rootViewController: exploreVC)

        let storyVC = StoryViewController()
        if #available(iOS 13.0, *) {
            storyVC.tabBarItem = UITabBarItem(title: "Câu chuyện", image: UIImage(systemName: "eye.fill"), tag: 2)
        } else {
            // Fallback on earlier versions
        }
        let storyViewModel = StoryViewModel()
        storyVC.viewModel = storyViewModel
        let storyNavi = UINavigationController(rootViewController: storyVC)

        let profileVC = ProfileViewController()
        if #available(iOS 13.0, *) {
            profileVC.tabBarItem = UITabBarItem(title: "Tài khoản", image: UIImage(systemName: "person.fill"), tag: 3)
        } else {
            // Fallback on earlier versions
        }
        let profileViewModel = ProfileViewModel()
        profileVC.viewModel = profileViewModel
        let profileNavi = UINavigationController(rootViewController: profileVC)

        self.viewControllers = [homeNavi, exploreNavi, storyNavi, profileNavi]
    }
}
