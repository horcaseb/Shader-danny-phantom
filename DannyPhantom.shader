Shader "Custom/DannyPhantom"
{
Properties
{
	_Texture1("textura ", 2D) = "whitte" {}
	_Color1("Color a cambiar",Color) = (1,1,1,1)
	_Factor("bordes No tocar mucho mejor = 0.7",Range(0,1)) = 1
	_Distancia("Pos",Range(0,1)) = 1
	_Transpfactor("transparencia No subir",Range(0,1)) = 1

}

SubShader
	{
			pass
			{
				ZWrite on
				ColorMask 0

			}
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "true"
			"RenderType" = "TransparentCutout"
		}
		LOD 200

		CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows alpha:fade

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _Texture1;
			float4 _Color1;
			float _Factor;
			float _Distancia;
			float _Transpfactor;



			//Siempre: uv_ + nombre de la textura
			struct Input
			{
				float2 uv_Texture1;
				float3 worldNormal;
				float3 viewDir;
				float3 worldPos;
			};

			void surf(Input IN, inout SurfaceOutputStandard o)
			{

				float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz; // convertir de worldpos a localpos
				fixed c = 0;

				float bordes = 1 - (dot(IN.viewDir, IN.worldNormal));
				float4 Original = tex2D(_Texture1, IN.uv_Texture1);
				float mascara = 0;


				if (bordes >= _Factor)
				{
					mascara = 1;
				}
				else
				{
					mascara = _Transpfactor; //_Transpfactor pinta en escala de grises al modelo segun el slider; blanco o negro
				}

				if (localPos.y <= _Distancia && localPos.y > -1 * _Distancia) {
					c = _Transpfactor;

				}
				else {

					c = 0;
				}

				float3 paso1 = _Color1* c*mascara; //paso1 bordes y zona DP
				float3 paso2 = Original*(1-c); //textura
				float transparencia = (1 - c) + _Transpfactor; //solo se pone transparente el centro
				//o.Albedo = paso1 + paso2 + (_Transpfactor); // con + _Transpfactor se vé mas claro
				//o.Alpha = transparencia;
				//o.Albedo = paso2+paso1; // mejor sin _Transpfactor
				o.Albedo =paso1+paso2;
				o.Alpha =transparencia;
				o.Emission = paso1;
			}

			ENDCG
	}
		FallBack "Diffuse"
}
