Shader "Custom/Exo1F1" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Radius("Radius", float) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _Radius;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float dist = distance(IN.uv_MainTex, float2(0.5, 0.5));
			if (abs(dist) > _Radius)     clip(-1.0);
			float val = dist * 20;
			float c1 = 1 - sin(val + _Time.x) + 0.5;
			float c2 = cos(val + _Time.y) + 0.5;
			float c3 = 0;
			o.Albedo = float3(c1, c2, c3) * 3;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
