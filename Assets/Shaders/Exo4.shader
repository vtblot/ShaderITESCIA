Shader "Unlit/Exo4"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Alpha("Transparency Alpha",Range(0.0,1)) = 1
		_NAnimations("N Animations",Int) = 4 // nombre d'animations contenues dans la spritesheet ... ici 4 pour la spritesheet de Link
		_NFramesPerAnimation("N Frames Per Animation",Int) = 10 // nombre de frames par animation .... ici 10 pour la spritesheet de Link
		_AnimationIndex("Animation Index",Int) = 0 // l'indice basé-0 de l'animation ... a priori entre 0 et 3 pour la spritesheet de Link
		_DurationBetweenFrames("Duration Between Frames",Range(0.0,1)) = .1  //  la durée entre deux frames d'animation ... .1 pour 10 frames par seconde, 0.0417 pour 24 images par seconde ...etc

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
			fixed _Alpha;
			int _NAnimations;
			int _NFramesPerAnimation;
			int _AnimationIndex;
			float2 _DurationBetweenFrames;
			
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
				
				float2 sizeSprite = float2(1.0 / _NFramesPerAnimation, 1.0 / _NAnimations);
				int currentFrame = floor((_Time.y / _DurationBetweenFrames) % _NFramesPerAnimation);
				float2 nextFrame = float2(sizeSprite.x*currentFrame, sizeSprite.y*_AnimationIndex); //Ligne a changer
				float2 st = nextFrame + float2(i.uv.x * sizeSprite.x, i.uv.y * sizeSprite.y);
				col = tex2D(_MainTex, st);
				//col.a = _Alpha;

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
