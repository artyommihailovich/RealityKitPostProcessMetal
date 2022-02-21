//
//  CameraViewController.swift
//  RealityKitPostProcessMetal
//
//  Created by Artyom Mihailovich on 2/1/22.
//

import UIKit

final class CameraViewController: UIViewController {
    
    weak var coordinator: AppCoordinator?
    
    private lazy var arView = CustomARView().do {
        $0.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        arView.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        arView.session.pause()
    }
    
    private func setupSubviews() {
        view.addSubview(arView)
    }
}
