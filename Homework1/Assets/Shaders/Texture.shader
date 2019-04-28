Shader "CM163/Texture" // shader name and file location
{
    Properties // Define the properties of the affected material (serialized fields)
    {
        _MainTex ("Texture", 2D) = "white" {} // A base/default texture that can be changed
		_Color ("Color", Color) = (1, 1, 1, 1) // A base color can be changed
		_SpecularColor ("Specular Color", Color) = (1, 1, 1, 1) // A base SpecColor that can be changed
		_Shininess ("Shininess", Float) = 1.0 // A base shininess that can be changed
	}
		SubShader // First shader to be used of renderable by the GPU
	{

		Pass // Only one pass, so the objects geometry is only rendered once
		{
			Tags {"LightMode" = "ForwardAdd"} // Additive per-pixel lights are applied, one pass per light

			//Blend One One // Can blend all scene lights to affect shader (currently just makes it too bright)

			CGPROGRAM // C for graphics
			#pragma vertex vert // These let the compiler know that the program contains both a vertex function and a fragment function
			#pragma fragment frag

			#include "UnityCG.cginc" // Include Unity's premade delcarations and functions

			float4 _LightColor0; // Declare the seriliazed fields in function for further use
			float4 _Color;
			float4 _SpecularColor;
			float4 _Shininess;


			sampler2D _MainTex; // Declare the two dimensional main texture
			
            struct VertexShaderInput // Define type that will take in Unity's scene data
            {
                float4 vertex : POSITION;
				float3 normal: NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct VertexShaderOutput // Define type to be used by the frag function
            {
                float2 uv : TEXCOORD0;
				//float3 normal: NORMAL;
				float3 normalInWorldCoords : NORMAL;
				float3 vertexInWorldCoords: float3;
                float4 vertex : SV_POSITION;
            };

            

            VertexShaderOutput vert (VertexShaderInput v) // Vert function takes in appdata and converts it to be legible by the frag shader
            {
                VertexShaderOutput o; // DEfine the return variable using our struct
                
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); // Vertex position in WORLD coords
				//o.normal = v.normal; //Normal 
				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); // Normal in WORLD coords

                o.vertex = UnityObjectToClipPos(v.vertex); //Transforms a point from object space to the camera’s clip space in homogeneous coordinates
                o.uv = v.uv; // Give the return variable the texture coordiantes of the inputted texel
                return o;
            }

            float4 frag (VertexShaderOutput i) : SV_Target // Change the color of each texel based on the input texture and the lighting on the object
            {
				float3 Ka = float3(1,1,1); // Base ambience
				float3 globalAmbient = float3(0.8, 0.1, 0.1);
				float3 ambientComponent = Ka * globalAmbient; // Combined ambience

				float3 P = i.vertexInWorldCoords.xyz; // Worldspace position, I beleive
				float3 N = normalize(i.normalInWorldCoords); // Normal, the surface normal of this pixel
				float3 L = normalize(_WorldSpaceLightPos0.xyz - P); // Light, points to the point light
				float3 Kd = _Color.rgb; //Color of object
				float3 lightColor = _LightColor0.rgb; //Color of light
				float3 diffuseComponent = Kd * lightColor + max(dot(N, L), 0); // Lighting spread over object

				float3 Ks = _SpecularColor.rgb; //Color of specular highlighting
				float3 V = normalize(_WorldSpaceCameraPos - P); // View, points to the camera
				float3 H = normalize(L + V); // Half, vector halfway between the V an L vectors, and is used to calculate specular highlights
				float3 specularComponent = Ks * lightColor * pow(max(dot(N, H), 0), _Shininess); // Lighting "shining" on the surface closest to it

				float3 finalColor = ambientComponent + diffuseComponent + specularComponent; // Final texel color combines all calculated lighting elements

				return float4(finalColor, 1.0) * tex2D(_MainTex, i.uv); // Return the original texel color multiplid by the lighting coloring

                // sample the texture
                //float4 col = tex2D(_MainTex, i.uv);
                //return col;
            }
            ENDCG // end of C for graphics
        }
    }
}
