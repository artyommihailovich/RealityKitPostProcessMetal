//
//  PostProcess.metal
//  RealityKitPostProcessMetal
//
//  Created by Artyom Mihailovich on 2/1/22.
//


#include <metal_stdlib>
using namespace metal;

constant int filterIndex [[function_constant(0)]];

[[kernel]]
void postProcess(uint2 gid [[thread_position_in_grid]],
                 texture2d<float, access::sample> inputTexture [[texture(0)]],
                 texture2d<float, access::write> outputTexture [[texture(1)]]) {
    
    if ((gid.x >= inputTexture.get_width()) || (gid.y >= inputTexture.get_height())) {
        return;
    }
    
    float4 sourceColor = inputTexture.read(gid);
    
    if (filterIndex == 0) { // Helium Blue
        float average = (sourceColor.r + sourceColor.g + sourceColor.b) * 0.25;
        float4 finalColor = float4(sourceColor.r - average, average, average, 1.0);
        outputTexture.write(finalColor, gid);
    }
    
    else if (filterIndex == 1) { // Black & White
        float average = (sourceColor.r + sourceColor.g + sourceColor.b) * 0.3;
        float4 finalColor = float4(average, average, average, 1.0);
        outputTexture.write(finalColor, gid);
    }
    
    else if (filterIndex == 2) { // Matrix Color Grading
        float4 finalColor;
        finalColor.r = pow(sourceColor.r, 3.0 * 0.5);
        finalColor.g = pow(sourceColor.g, 4.0 * 0.2);
        finalColor.b = pow(sourceColor.b, 3.0 * 0.5);
        finalColor.a = 1.0;
        outputTexture.write(finalColor, gid);
    }
    else {
        outputTexture.write(float4(0.0, 1.0, 0.0, 1.0), gid);
    }
}
