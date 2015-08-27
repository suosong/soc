Shader "VertexColor/PlayerDiffuse"
{
    Properties 
    {
		_MainTex	("Base (RGB) Trans (A)", 2D) = "white" {}
		_LightPower ("Light Power", Float) = 1
		_AlphaBlend ("Alpha Blend", Range(0,1)) = 1

		//> [add by Cool_J]
		//> 效果相关的属性
		//> -----------------------------------------------------------------
		//> 边缘光
		_RimColor	("Rim Color", Color)				= (0.57,0.57,0.56,0.0)
		_RimPower	("Rim Power", Range(0.6,9.0))		= 3.5
		_RimScalar	("Rim Scalar", Range(0.0,1.0))		= 0.65

		//> 叠色
		_ColorEff 	("Additive Color", Color) 			= (0,0,0,0)

		//> 溶解
		_DissolveTex("Dissolve(RGB)", 2D) 				= "white" {}
		_Burn		("Burn Amount", Range(-0.25, 1.25)) = 1.0
		_LineWidth	("Burn Line Size", Range(0.0, 0.2)) = 0.1
		_BurnColor	("Burn Color", Color) 				= (1.0, 0.0, 0.0, 1.0)		

    }

    SubShader
    {
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType"="Transparent" }
		LOD 		300
		ZWrite 		On
		Lighting 	Off
		Cull 		Back
		Blend		SrcAlpha	OneMinusSrcAlpha

		CGPROGRAM

		#pragma surface surf BasicDiffuse vertex:vert

		struct Input
		{
			float2 	uv_MainTex;
			float4 	VertColor;
			float4	RimColor;
			float3	ViewDir;
		};

		      
		float 			_LightPower;
		float			_AlphaBlend;
		sampler2D 		_MainTex;
		sampler2D 		_NomalTex;

		//> 效果相关的属性
		//> -----------------------------------------------------------------
		//> 边缘光
		float4			_RimColor;
		float			_RimPower;
		float			_RimScalar;

		//> 叠色
		float4			_ColorEff;
		//> 溶解
		sampler2D		_DissolveTex;
		float			_Burn;
		float			_LineWidth;
		float4			_BurnColor;

		void vert(inout appdata_full v, out Input o)    
		{
			float rim	= 1.0f - saturate( dot(normalize(ObjSpaceViewDir(v.vertex)), v.normal) );
			o.uv_MainTex= float2( v.texcoord.x, v.texcoord.y );
			o.VertColor = v.color; //+ clamp(pow(rim, 6.0f),0.0f,1.0f);
			o.ViewDir	= normalize( float3( float4( _WorldSpaceCameraPos.xyz, 1.0) - mul(_Object2World, v.vertex).xyz ) ); 
			o.RimColor	= _RimColor * pow(rim, _RimPower) * _RimScalar;
		} 

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float4 fCol = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo= fCol.rgb * IN.VertColor * _LightPower;
			o.Alpha = fCol.a;

			//> 法线图
			//> -----------------------------------------------------------------
			o.Normal = UnpackNormal( tex2D(_NomalTex, IN.uv_MainTex) );

			//> 边缘光颜色
			//> -----------------------------------------------------------------
			o.Emission = IN.RimColor.rgb;

			//> half rim = 1.0 - saturate(dot (normalize(IN.ViewDir), o.Normal));
			//> o.Emission = _RimColor * pow( rim, _RimPower ) * _RimScalar;

			//> 叠色效果
			//> -----------------------------------------------------------------
			o.Albedo += _ColorEff.rgb;

			//> 溶解效果
			//> -----------------------------------------------------------------
			half4 burnColor = tex2D(_DissolveTex, IN.uv_MainTex);
			half4 clear = half4(0.0, 0.0, 0.0, 0.0);
			
			clear = lerp(_BurnColor, clear, max(0.0, int(burnColor.r - (_Burn+_LineWidth) + 0.99)));
			o.Albedo = lerp(o.Albedo, clear, max(0.0,int(burnColor.r - _Burn + 0.99)));
			o.Alpha *= lerp(1.0, 0.0, int(burnColor.r - (_Burn+_LineWidth) + 0.99));
		}

		//> 最终受光照色彩影响的计算在这里进行，将surf中计算好的数据应用
		//> -----------------------------------------------------------------
		inline float4 LightingBasicDiffuse (SurfaceOutput s, float3 lightDir, float atten)  
		{
			half NdotL = dot (s.Normal, lightDir);
			half diff = NdotL * 0.5 + 0.5;

			//float diff = max (0, dot (s.Normal, lightDir));  

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
			c.a = s.Alpha * _AlphaBlend;
			return c;
		}

		ENDCG     
	}

	Fallback "Diffuse"
}
