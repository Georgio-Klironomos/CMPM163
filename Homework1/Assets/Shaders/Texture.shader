Shader "CM163/Texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
		_Shininess ("Shininess", Float) = 1.0
	}
		SubShader
	{

		Pass
		{
			Tags {"LightMode" = "ForwardAdd"}

			//Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _LightColor0;
			float4 _Color;
			float4 _SpecularColor;
			float4 _Shininess;


			sampler2D _MainTex;
			
            struct VertexShaderInput
            {
                float4 vertex : POSITION;
				float3 normal: NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct VertexShaderOutput
            {
                float2 uv : TEXCOORD0;
				//float3 normal: NORMAL;
				float3 normalInWorldCoords : NORMAL;
				float3 vertexInWorldCoords: float3;
                float4 vertex : SV_POSITION;
            };

            

            VertexShaderOutput vert (VertexShaderInput v)
            {
                VertexShaderOutput o;
                
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
				//o.normal = v.normal; //Normal 
				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal in WORLD coords

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; 
                return o;
            }

            float4 frag (VertexShaderOutput i) : SV_Target
            {
				float3 Ka = float3(1,1,1);
				float3 globalAmbient = float3(0.8, 0.1, 0.1);
				float3 ambientComponent = Ka * globalAmbient;

				float3 P = i.vertexInWorldCoords.xyz;
				float3 N = normalize(i.normalInWorldCoords);
				float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
				float3 Kd = _Color.rgb; //Color of object
				float3 lightColor = _LightColor0.rgb; //Color of light
				float3 diffuseComponent = Kd * lightColor + max(dot(N, L), 0);

				float3 Ks = _SpecularColor.rgb; //Color of specular highlighting
				float3 V = normalize(_WorldSpaceCameraPos - P);
				float3 H = normalize(L + V);
				float3 specularComponent = Ks * lightColor * pow(max(dot(N, H), 0), _Shininess);

				float3 finalColor = ambientComponent + diffuseComponent + specularComponent;

				return float4(finalColor, 1.0) * tex2D(_MainTex, i.uv);

                // sample the texture
                //float4 col = tex2D(_MainTex, i.uv);
                //return col;
            }
            ENDCG
        }
    }
}
