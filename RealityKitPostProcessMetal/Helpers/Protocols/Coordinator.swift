//
//  Coordinator.swift
//  RealityKitPostProcessMetal
//
//  Created by Artyom Mihailovich on 2/1/22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
