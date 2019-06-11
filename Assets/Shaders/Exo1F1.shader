Shader "Unlit/Exo1F1"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BackgroundColor("Background Color", Color) = (0,0,1,1)
		_BandStartColor("Band Start Color", Color) = (0.25,0,0,1)
		_BandEndColor("Band End Color", Color) = (1,0,0,1)
		_NumberOfBands("Number Bands", Int) = 5
		_CircleRadius("Circle Radius", Range(0.01,0.5)) = 0.5
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
			int _NumberOfBands;
			fixed _CircleRadius;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				float2 center = float2(0.5f, 0.5f);
				float distanceToCenter = distance(i.uv, center);
				col = _BackgroundColor;

				float isInCircle = 1 - smoothstep(_CircleRadius - .5f, _CircleRadius + .5f, distanceToCenter);

				float4 circleColor = _BandStartColor;

				float bandWidth = (_CircleRadius) / (float)_NumberOfBands;

				float4  startColor = lerp(_BandStartColor, _BandEndColor, step(center.y, i.uv.y));
				float4  endColor = lerp(_BandEndColor, _BandStartColor, step(center.y, i.uv.y));

				//float bandID = floor(((0.5 - _CircleRadius)) / bandWidth);

				//circleColor = lerp(startColor, endColor, 1);
				if (distanceToCenter < 0.2f)
				{
					col = lerp(col, _BandEndColor, isInCircle);
				}

				col = lerp(col, circleColor, isInCircle);

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
