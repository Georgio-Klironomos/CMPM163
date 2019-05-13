// WORKS CITED: https://www.youtube.com/watch?v=OJkGGuudm38
Shader "Custom/XRayReplace"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1) // Instantiate the base color
		_EdgeColor("XRay Edge Color", Color) = (0,0,0,0) // Instantiate the color of the xRay outline
		_MainTex("Base (RGB)", 2D) = "white" {} // Instantiate the texture's base color
	}

		SubShader
	{
		Tags
		{ // Kept in the tutorial comments, they are helpful lol
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		// In some cases, it's necessary to force XRay objects to render before the rest of the geometry	//
		// This is so their depth info is already in the ZBuffer, and Occluding objects won't mistakenly	//
		// write to the Stencil buffer when they shouldn't.													//
		//																									//
		// This is what "Queue" = "Geometry-1" is for.														//
		// I didn't bring this up in the video because I'm an idiot.										//
		//																									//
		// Cheers,																							//
		// Dan																								//
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		"Queue" = "Geometry-1" // Tell the gpu to render the x-ray before the geometry
		"RenderType" = "Opaque" // Categorize shader into predefined group
		"XRay" = "ColoredOutline" // Connent this shader to the replacement shader
	}
	LOD 200 // Cap the level of detail at 200

	CGPROGRAM // C for Graphics
	#pragma surface surf Lambert // Use Unity's established Lambert lighting model

	sampler2D _MainTex;
	fixed4 _Color;

	struct Input { // Essentially a v2f function
		float2 uv_MainTex;
	};

	void surf(Input IN, inout SurfaceOutput o) // This surface shader doesn't do much, except wait to get replaced
	{
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		o.Alpha = c.a;
	}
	ENDCG
	}

		Fallback "Diffuse"
}
