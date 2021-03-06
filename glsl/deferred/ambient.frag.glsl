
#version 100
precision highp float;
precision highp int;

#define NUM_GBUFFERS 2

uniform sampler2D u_gbufs[NUM_GBUFFERS];
uniform sampler2D u_depth;

varying vec2 v_uv;

void main() {
#if NUM_GBUFFERS == 2
    vec4 gb2 = texture2D(u_gbufs[1], v_uv);
#elif NUM_GBUFFERS > 2
    vec4 gb2 = texture2D(u_gbufs[2], v_uv);
#endif
    
    float depth = texture2D(u_depth, v_uv).x;
    // TODO: Extract needed properties from the g-buffers into local variables
    vec3 ambientColor = gb2.rgb * 0.2;

    if (depth == 1.0) {
        gl_FragColor = vec4(0, 0, 0, 0); // set alpha to 0
        return;
    }

    gl_FragColor = vec4(ambientColor, 1);  // TODO: replace this
}
