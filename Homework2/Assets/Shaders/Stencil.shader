// WORKS CITED: https://www.youtube.com/watch?v=OJkGGuudm38
Shader "Custom/Stencil"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

		Stencil { // Stencil is a per pixel mask for saving or discarding pixels
			Ref 1 // The value to be written to the buffer
			Comp Always // Compares the reference value to the current buffer contents
			Pass Replace // What to do with the contents of the buffer if the stencil test passes
			ZFail Keep // what to do with the contents of the buffer if the stencil test passes but the depth test fails
		}

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        sampler2D _MainTex;
		fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
