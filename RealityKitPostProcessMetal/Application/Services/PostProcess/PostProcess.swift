//
//  PostProcess.swift
//  RealityKitPostProcessMetal
//
//  Created by Artyom Mihailovich on 2/1/22.
//

import ARKit
import MetalKit
import RealityKit

final class PostProcess {
    
    enum PostProcessState {
        case on
        case off
    }
    
    private weak var arView: CustomARView?
    
    private var postProcessPipelines: [FunctionConstants: MTLComputePipelineState] = [:]
    private var postProcessState: PostProcessState = .on
    
    var selectedFilter: Filter = .heliumBlue
    
    init(arView: CustomARView) {
        self.arView = arView
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setupRenderCallback()
        }
    }
    
    private func postProcessPipeline(for constants: FunctionConstants) throws -> MTLComputePipelineState {
        var constants2 = constants
        let metalConstants = MTLFunctionConstantValues().do {
            $0.setConstantValue(&constants2.filterIndex, type: .int, index: 0)
        }
        let function = try MetalLibLoader.library.makeFunction(name: "postProcess", constantValues: metalConstants)
        return try MetalLibLoader.mtlDevice.makeComputePipelineState(function: function)
    }
    
    func switchPostProcessState() {
        switch postProcessState {
        case .on:
            postProcessNone()
            postProcessState = .off
        case .off:
            setupRenderCallback()
            postProcessState = .on
        }
    }
}

extension PostProcess {
    
    private func setupRenderCallback() {
        arView?.renderCallbacks.postProcess = { [weak self] in
            guard let self = self else { return }
            self.postProcess(context: $0)
        }
    }
    
    private func postProcessNone() {
        arView?.renderCallbacks.postProcess = {
            let blitEncoder = $0.commandBuffer.makeBlitCommandEncoder()
            blitEncoder?.copy(from: $0.sourceColorTexture, to: $0.targetColorTexture)
            blitEncoder?.endEncoding()
        }
    }
    
    private func postProcess(context: ARView.PostProcessContext) {
        let postProcessPipeline: MTLComputePipelineState
        
        do {
            postProcessPipeline = try self.postProcessPipeline(for: .init(filterIndex: selectedFilter.rawValue))
        } catch {
            assertionFailure("\(error)")
            return
        }
        
        guard let encoder = context.commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        
        encoder.setComputePipelineState(postProcessPipeline)
        encoder.setTexture(context.sourceColorTexture, index: 0)
        encoder.setTexture(context.targetColorTexture, index: 1)
        
        let threadsPerGrid = MTLSize(width: context.sourceColorTexture.width,
                                     height: context.sourceColorTexture.height,
                                     depth: 1)
        
        let width = postProcessPipeline.threadExecutionWidth
        let height = postProcessPipeline.maxTotalThreadsPerThreadgroup / width
        let threadsPerThreadgroup = MTLSizeMake(width, height, 1)
        
        encoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
    }
}
