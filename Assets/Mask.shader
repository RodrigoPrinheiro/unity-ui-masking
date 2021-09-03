// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Mask" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader {
    Tags {"Queue" = "Transparent" }
    
    Blend One OneMinusSrcAlpha
        Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        sampler2D _MainTex;

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
            float4 color : COLOR;
        };

        struct v2f {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            fixed4 color : COLOR;
        };

        float4 _MainTex_ST;

        v2f vert (appdata v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos (v.vertex);
            o.uv = TRANSFORM_TEX (v.uv, _MainTex);
            o.color = v.color;
            return o;
        }

         fixed4 frag (v2f i) : SV_Target
        {
            fixed4 texcol = tex2D (_MainTex, i.uv);
            fixed4 outputColor = i.color;
            outputColor.a -= texcol.r;
            return outputColor ;
        }
        ENDCG

        }
    }
}