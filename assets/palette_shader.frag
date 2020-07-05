// https://www.khronos.org/opengl/wiki/Common_Mistakes#Paletted_textures
// Fragment shader
uniform sampler2D Palette;
uniform sampler2D Texture;

void main()
{
  vec4 index = texture2D(Texture, gl_TexCoord[0].xy);
  vec4 texel = texture2D(Palette, vec2(index.x, 0));
  gl_FragColor = vec4(texel.rgb, index.a);
}