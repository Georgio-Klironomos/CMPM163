﻿Shader "Custom/Outline"
{
    Properties
    {
		_Outline("Outline", Float) = 0
	}
		SubShader
	{
		Pass{
			Cull Front

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			 #include "UnityCG.cginc"

			float _Outline;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normalInWorldCoords : NORMAL;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				v.vertex += float4(v.normal, 1.0) * _Outline;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f i) : SV_Target
			{


				return float4(1, 1, 1, 0);
			}

			ENDCG
		}

		Pass{
		//Cull Front

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			 #include "UnityCG.cginc"

			float _Outline;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normalInWorldCoords : NORMAL;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				//v.vertex += float4(v.normal, 1.0) * _Outline;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f i) : SV_Target
			{


				return float4(1, 1, 0, 0);
			}

			ENDCG
		}
    }
    FallBack "Diffuse"
}
