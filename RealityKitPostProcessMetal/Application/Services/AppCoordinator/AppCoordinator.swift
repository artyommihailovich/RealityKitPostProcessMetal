//
//  AppCoordinator.swift
//  RealityKitPostProcessMetal
//
//  Created by Artyom Mihailovich on 2/1/22.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = CameraViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}
