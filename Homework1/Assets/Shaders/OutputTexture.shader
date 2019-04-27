Shader "Custom/OutputTexture" // Define file name and location
{
    Properties // Define material properties
    {
        _MainTex ("Texture", 2D) = "white" {} // Establish an editable from editor texture field
    }
    SubShader // First subshader, used by graphics card if renderable
    {
        Tags { "RenderType"="Opaque" } // This shader falls into the predefined category of opaque
        
		Pass // First pass, so game object's geometry is only rendered once
		{

			CGPROGRAM // C for graphics
			#pragma vertex vert // Define vertex function to the compiler
			#pragma fragment frag // Define fragment function to the compiler

			#include "UnityCG.cginc" // Include Unity's premade declarations and functions, for speed

			struct appdata // Define type that Unity's data can fit into
			{
				float4 vertex : POSITION; // vertex position in 3D worldspace
				float2 uv: TEXCOORD0; // vertex position on 2D texture
			};

			struct v2f // Define type legible to the GPU
			{
				float4 vertex : SV_POSITION; // Graphics semantic for cameraspace position
				float2 uv: TEXCOORD0; // vertex position on 2D texture
			};

			sampler _MainTex; // Declare the inputed texte within the CGPROGRAM

			v2f vert(appdata v) // Take in the Unity data and translate it into GPU legible data
			{
				v2f output;
				output.vertex = UnityObjectToClipPos(v.vertex);
				output.uv = v.uv;
				return output;
			}

			fixed4 frag(v2f i) : SV_Target // Take the vertex info and tell the compiler the output will be one piece of data
			{
				float4 c = tex2D(_MainTex, i.uv);  // Define the color of the inputted texel
                //return float4(1.0 -c.r, 1.0-c.r, 1.0-c.r, 1.0);
				return float4(c.r, c.g, c.b, c.a); // Return the colors of the input texel
			}	
			ENDCG // Let the compiler know that's the end of this C for graphics program
		} 
    }
    FallBack "Diffuse" // In case the pass fails/can't be rendered, render this instead
}
