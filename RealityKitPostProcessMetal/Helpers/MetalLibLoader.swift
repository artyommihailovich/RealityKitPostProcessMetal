//
//  MetalLibLoader.swift
//  RealityKitPostProcessMetal
//
//  Created by Artyom Mihailovich on 2/1/22.
//

import MetalKit

struct MetalLibLoader {
    static var isInitialized = false
    static var textureCache: CVMetalTextureCache!
    static var mtlDevice: MTLDevice!
    static var library: MTLLibrary!
    
    static func initializeMetal() {
        guard !isInitialized else { return }
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError()
        }
        
        mtlDevice = device
        
        if CVMetalTextureCacheCreate(nil, nil, device, nil, &textureCache) != kCVReturnSuccess {
            fatalError()
        }
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError()
        }
        self.library = library
        
        isInitialized = true
    }
}
