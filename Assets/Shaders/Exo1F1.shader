Shader "Unlit/Exo1F1"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BackgroundColor("Background Color", Color) = (0,0,1,1)
		_BandStartColor("Band Start Color", Color) = (0.25,0,0,1)
		_BandEndColor("Band End Color", Color) = (1,0,0,1)
		_CircleRadius("Circle Radius", Range(0.01,1)) = 1
		_NbCircle("Nb Circle", Int) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _BackgroundColor;
			fixed4 _BandStartColor;
			fixed4 _BandEndColor;
			fixed _CircleRadius;
			fixed _NbCircle;
			
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float2 center = float2(0.5f, 0.5f);

				col = _BackgroundColor;

				float distanceToCenter = distance(i.uv, center);

				float circleSize = _CircleRadius / _NbCircle;

				float CircleID = floor(distanceToCenter / circleSize);

				float isInCircle = 1 - smoothstep(_CircleRadius - .001f, _CircleRadius + .001f, distanceToCenter);

				float4 circleColor = _BandStartColor;

				circleColor = lerp(_BandStartColor, _BandEndColor, CircleID / (_NbCircle - 1));

				col = lerp(col, circleColor, isInCircle);

				return col;
			}
			ENDCG
		}
	}
}
