// CRT scanline effect for the SDDM SEL theme.
// Qt 6 RHI fragment shader. Compile with:
//   /usr/lib/qt6/bin/qsb --qt6 -o crt.frag.qsb crt.frag
#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

// The uniform block must keep qt_Matrix and qt_Opacity first so its
// layout stays compatible with ShaderEffect's built-in vertex shader.
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float iTime;
    float iHeight;
};

layout(binding = 1) uniform sampler2D source;

float scanline(vec2 uv) {
    return sin(iHeight * uv.y * 0.7 - iTime * 10.0);
}

float slowscan(vec2 uv) {
    return sin(iHeight * uv.y * 0.02 + iTime * 6.0);
}

void main() {
    vec2 uv = qt_TexCoord0;
    vec4 color = texture(source, uv);

    vec4 scanline_color = vec4(scanline(uv));
    vec4 slowscan_color = vec4(slowscan(uv));

    fragColor = mix(color, mix(scanline_color, slowscan_color, 0.25), 0.05) * qt_Opacity;
}
