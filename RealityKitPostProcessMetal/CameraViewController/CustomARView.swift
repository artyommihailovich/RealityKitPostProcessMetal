//
//  CustomARView.swift
//  RealityKitPostProcessMetal
//
//  Created by Artyom Mihailovich on 2/1/22.
//

import ARKit
import RealityKit

final class CustomARView: ARView {
    
    private var postProcess: PostProcess?
    
    func setup() {
        postProcess = .init(arView: self)
        configureWorldTracking()
        setupSwipeGestures()
        setupTapGesture()
    }
    
    private func configureWorldTracking() {
        automaticallyConfigureSession = false
        cameraMode = .ar

        _ = ARWorldTrackingConfiguration().do {
            $0.planeDetection = .horizontal
            session.run($0)
        }
        renderOptions.insert(.disableMotionBlur)
    }
    
    private func setupSwipeGestures() {
        _ = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesturesAction)).do {
            $0.direction = .left
            addGestureRecognizer($0)
        }
        
        _ = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesturesAction)).do {
            $0.direction = .right
            addGestureRecognizer($0)
        }
    }
    
    private func setupTapGesture() {
        _ = UITapGestureRecognizer().do {
            $0.numberOfTapsRequired = 1
            $0.addTarget(self, action: #selector(tapGestureRecognizerAction))
            addGestureRecognizer($0)
        }
    }
    
    @objc
    private func swipeGesturesAction(_ gesture: UISwipeGestureRecognizer) {
        let currentIndex = Filter.allCases.firstIndex(of: postProcess?.selectedFilter ?? .blackAndWhite) ?? 0
        switch gesture.direction {
        case .left:
            postProcess?.selectedFilter = Filter.allCases[(currentIndex + 1) % Filter.allCases.count]
        case .right:
           postProcess?.selectedFilter = Filter.allCases[(currentIndex - 1 + Filter.allCases.count) % Filter.allCases.count]
        default:
            break
        }
    }
    
    @objc
    private func tapGestureRecognizerAction() {
        postProcess?.switchPostProcessState()
    }
}
