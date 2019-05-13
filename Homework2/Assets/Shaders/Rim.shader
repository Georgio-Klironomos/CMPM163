//WORKS CITED: https://www.youtube.com/watch?v=OJkGGuudm38

Shader "Custom/Rim" {
	Properties {
	  _EdgeColor("Edge Color", Color) = (1,1,1,1)
	}

	SubShader{
		Stencil{ // Stencil is a per pixel mask for saving or discarding pixels
			Ref 0 // The value to be written to the buffer
			Comp NotEqual // Compares the reference value to the current buffer contents
		}
		  
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"XRay" = "ColoredOutline"
		}

		ZWrite Off // Controls whether pixels from this object are written to the depth buffer
		ZTest Always // How depth testing should be performed
		Blend One One // Activates additive blending

		Pass{ // Only one rendering pass
			CGPROGRAM // begin C for graphics

			#pragma vertex vert // Tell the compiler this contains a vertex and a fragment shader
			#pragma fragment frag

			#include "UnityCG.cginc" // Get those sweet Unity includes

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD1;
			};

			v2f vert(appdata v) {
				v2f output;
				output.vertex = UnityObjectToClipPos(v.vertex); // transform the vertex position from world space to camera clip space
				output.uv = v.uv;
				output.normal = UnityObjectToWorldNormal(v.normal); // Because we want the worldpace normals instead of the surface normals
				output.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz); // Get the direction of view to the object
				return output;
			}

			float4 _EdgeColor;

			fixed4 frag (v2f i) : SV_Target {
				float NdotV = (1 - dot(i.normal, i.viewDir) * 1.5); // get the dot product of the point's normal and view direction 
				return _EdgeColor * NdotV; // return the edge color from the points we select
			}
			ENDCG
		}
	}
		Fallback "Diffuse"
}