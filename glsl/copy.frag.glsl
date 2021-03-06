#version 100
#extension GL_EXT_draw_buffers: enable
precision highp float;
precision highp int;

#define NUM_GBUFFERS 2

uniform sampler2D u_colmap;
uniform sampler2D u_normap;

varying vec3 v_position;
varying vec3 v_normal;
varying vec2 v_uv;

vec3 applyNormalMap(vec3 geomnor, vec3 normap) {
    normap = normap * 2.0 - 1.0;
    vec3 up = normalize(vec3(0.001, 1, 0.001));
    vec3 surftan = normalize(cross(geomnor, up));
    vec3 surfbinor = cross(geomnor, surftan);
    return normap.y * surftan + normap.x * surfbinor + normap.z * geomnor;
}

void main() {
    // TODO: copy values into gl_FragData[0], [1], etc.
    // You can use the GLSL texture2D function to access the textures using
    // the UV in v_uv.
    vec4 color = texture2D(u_colmap, v_uv);
    vec4 normap = texture2D(u_normap, v_uv);

    vec3 nor = normalize(applyNormalMap(v_normal, normap.xyz));

    // this gives you the idea
    gl_FragData[0] = vec4( v_position, nor[0] );

#if NUM_GBUFFERS == 2
    gl_FragData[1] = vec4( color.rgb, nor[1]);
#elif NUM_GBUFFERS == 3
    gl_FragData[1] = vec4( nor, nor[1]);
    gl_FragData[2] = color;
#elif NUM_GBUFFERS == 4
    gl_FragData[1] = vec4( v_normal, 0.0);
    gl_FragData[2] = color;
    gl_FragData[3] = normap;
#endif
}
