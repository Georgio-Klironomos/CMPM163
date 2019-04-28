
//Adapted from Example 5.3 in The CG Tutorial by Fernando & Kilgard
Shader "Custom/Phong"
{
    Properties
    {   
        _Color ("Color", Color) = (1, 1, 1, 1) //The color of our object
        _Shininess ("Shininess", Float) = 10 //Shininess
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
    }
    
    SubShader
    {
        Pass {
            Tags { "LightMode" = "ForwardAdd" } //Important! In Unity, point lights are calculated in the the ForwardAdd pass
            Blend One One //Turn on additive blending if you have more than one point light
          
            
            CGPROGRAM
            #pragma vertex vert // Define the vert and frag functions to the compiler
            #pragma fragment frag

            #include "UnityCG.cginc" // include Unity's prebuilt shader declarations and functions
            
           
            uniform float4 _LightColor0; //From UnityCG
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess;          
          
            struct appdata // type to hold scene data
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
            };

            struct v2f // type legible to the frag func/GPU
            {
                    float4 vertex : SV_POSITION;
					//float3 normal: NORMAL;
					float3 normalInWorldCoords : NORMAL;
                    float3 vertexInWorldCoords : TEXCOORD1;
            };

 
           v2f vert(appdata v) // convert scene texture data to be used by the GPU
           { 
                v2f o;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
			  //o.normal = v.normal; //Normal 
				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal in WORLD coords
                o.vertex = UnityObjectToClipPos(v.vertex); // Transforms a point from object space to the camera’s clip space in homogeneous coordinates
                return o;
           }

           fixed4 frag(v2f i) : SV_Target // Modify the vertices of the texture to color fragments for the GPU
           {
                
                float3 P = i.vertexInWorldCoords.xyz; // Worldspace position of the vertex
                float3 N = normalize(i.normalInWorldCoords); // Surface normal of the texel
                float3 V = normalize(_WorldSpaceCameraPos - P); // View vector, points to the camera
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P); // light vector, points to the light affecting the object
                float3 H = normalize(L + V); // halway between light and view, used to calbulate specular highlights
                
                float3 Kd = _Color.rgb; //Color of object
                float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                //float3 Ka = float3(0,0,0); //UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                float3 Ks = _SpecColor.rgb; //Color of specular highlighting
                float3 Kl = _LightColor0.rgb; //Color of light
                
                
                //AMBIENT LIGHT 
                float3 ambient = Ka;
               
                //DIFFUSE LIGHT
                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = Kd * Kl * diffuseVal;
                
                //SPECULAR LIGHT
                float specularVal = pow(max(dot(N,H), 0), _Shininess);
                
                if (diffuseVal <= 0) {
                    specularVal = 0;
                }
                
                float3 specular = Ks * Kl * specularVal;
                
                //FINAL COLOR OF FRAGMENT
                return float4(ambient + diffuse + specular, 1.0);
                //return float4(ambient, 1.0);

            }
            
            ENDCG
 
            
        }
            
    }
}
