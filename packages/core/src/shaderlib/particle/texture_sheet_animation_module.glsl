#if defined(RENDERER_TSA_FRAME_CURVE) || defined(TEXTURE_SHEET_ANIMATION_RANDOM_CURVE)
    uniform float renderer_TSACycles;
    uniform vec3 renderer_TSATillingParams; // x:subU  y:subV z:tileCount
    uniform vec2 renderer_TSAFrameMaxCurve[4]; // x:time y:value
#endif

#ifdef TEXTURE_SHEET_ANIMATION_RANDOM_CURVE
    uniform vec2 renderer_TSAFrameMinCurve[4]; // x:time y:value
#endif


#if defined(RENDERER_TSA_FRAME_CURVE) || defined(TEXTURE_SHEET_ANIMATION_RANDOM_CURVE)
    float getFrameFromGradient(in vec2 gradientFrames[4], in float normalizedAge) {    
        return floor(evaluateParticleCurve(gradientFrames,normalizedAge) * renderer_TSATillingParams.z);
    }
#endif

vec2 computeParticleUV(in vec2 uv, in float normalizedAge) {
    #ifdef RENDERER_TSA_FRAME_CURVE
        float cycleNormalizedAge = normalizedAge * renderer_TSACycles;
        float frame = getFrameFromGradient(renderer_TSAFrameMaxCurve, cycleNormalizedAge - floor(cycleNormalizedAge));
        float totalULength = frame * renderer_TSATillingParams.x;
        float floorTotalULength = floor(totalULength);
        uv.x += totalULength - floorTotalULength;
        uv.y += floorTotalULength * renderer_TSATillingParams.y;
    #endif

    #ifdef TEXTURE_SHEET_ANIMATION_RANDOM_CURVE
        float cycleNormalizedAge = normalizedAge * renderer_TSACycles;
        float uvNormalizedAge = cycleNormalizedAge - floor(cycleNormalizedAge);
        float frame = floor(mix(getFrameFromGradient(u_TSAGradientUVs, uvNormalizedAge),
        getFrameFromGradient(renderer_TSAFrameMaxCurve, uvNormalizedAge),a_Random1.x));
        float totalULength = frame * renderer_TSATillingParams.x;
        float floorTotalULength = floor(totalULength);
        uv.x += totalULength - floorTotalULength;
        uv.y += floorTotalULength * renderer_TSATillingParams.y;
    #endif
   
    return uv;
}