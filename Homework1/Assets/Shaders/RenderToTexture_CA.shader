Shader "Custom/RenderToTexture_CA" // File name and location
{
	Properties // Material properties
	{
		_MainTex("Texture", 2D) = "white" {} 
    }
	SubShader // Graphics card uses first subshader that works
	{
		Tags { "RenderType" = "Opaque" } // Categorize shader into predefined opaque shader
		
		Pass // Cause the geometry of the game object to be rendered once
		{
				// C for graphics
			CGPROGRAM
				// INform the compiler that this program includea a vertex code block and a fragment code block
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc" // Include common declarations and functions
            
            uniform float4 _MainTex_TexelSize;
           
				// Define type to take in data from Unity
			struct appdata
			{
				float4 vertex : POSITION; // vertex is worldspace coordinates
				float2 uv: TEXCOORD0; // uv is texture coodinates
			};
				// Define datatype that is legible to the fragment function
			struct v2f
			{
				float4 vertex : SV_POSITION; // SV_POSITION is worldspace coordinates that is legible to the graphics pipeline
				float2 uv: TEXCOORD0; // uv is texture coodinates
			};
				// Take in appdata and translate it into shaderdata
			v2f vert(appdata v)
			{
				v2f output;
				output.vertex = UnityObjectToClipPos(v.vertex); // Transforms a point from object space to the camera’s clip space in homogeneous coordinates
				output.uv = v.uv;
				return output;
			}
            
				// Just a 2D texture
            sampler2D _MainTex; 
				// Take in the translated vertex data and, in this case, affect the texel's colors based on Conway rules
				// Return a fixed4, which is smaller that a float4, for faster GPU processing
			fixed4 frag(v2f i) : SV_Target // Tell the compiler this function returns only one piece of data
			{
					// Define a texel as a coordinate position on the texture
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
                
					// Define these as the input's x/y pos
                float cx = i.uv.x;
                float cy = i.uv.y;
					// Define the color of the passed in texel
                float4 C = tex2D( _MainTex, float2( cx, cy ));   
					// Define direction of this texel's neighbor
                float up = i.uv.y + texel.y * 1;
                float down = i.uv.y + texel.y * -1;
                float right = i.uv.x + texel.x * 1;
                float left = i.uv.x + texel.x * -1;
					// it's an array
                float4 arr[8];
					// Fill array with color information of the neighbour
                arr[0] = tex2D(  _MainTex, float2( cx   , up ));   //N
                arr[1] = tex2D(  _MainTex, float2( right, up ));   //NE
                arr[2] = tex2D(  _MainTex, float2( right, cy ));   //E
                arr[3] = tex2D(  _MainTex, float2( right, down )); //SE
                arr[4] = tex2D(  _MainTex, float2( cx   , down )); //S
                arr[5] = tex2D(  _MainTex, float2( left , down )); //SW
                arr[6] = tex2D(  _MainTex, float2( left , cy ));   //W
                arr[7] = tex2D(  _MainTex, float2( left , up ));   //NW
					// Establish counter for living, neighboring cells (Moore style)
                int cnt = 0;
					// Loop through each neighbor and check for # of live ones
                for (int i=0; i<8; i++) {
                    if (arr[i].g > 0.5 || arr[i].b > 0.5) {
                        cnt++;
                    }
                }
                        
					// if this Texel is alive
                if (C.g >= 0.5 || C.b >= 0.5) {
						// Any live cell with two/three/seven live neighbours lives on to the next generation
                    if ( cnt == 2 || cnt == 3 || cnt == 7) {
							// Continuous life is colored blue
                        return float4(0.0,0.0,1.0,1.0);
                    } 
					else {
							//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
							//Any live cell with more than three live neighbours dies, as if by overpopulation. (except on a lucky 7)
							// Dead cells are colored red
                        return float4(1.0,0.0,0.0,0.0);
                    }
                } 
				else { // if this Texel is alive
						//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
                    if (cnt == 3 || cnt == 7) {
							// Ressurected cells are colored green
                        return float4(0.0,1.0,0.0,1.0);
                    } 
					else {
							// Dead cells are colored red
                        return float4(1.0,0.0,0.0,0.0);

                    }
                }
                
            }
				// Let the compiler know that's the end of this C for graphics program
			ENDCG
		}

	}
		// In case the pass fails/can't be rendered, render this instead
	FallBack "Diffuse"
}