// This shader fills the mesh shape with a color predefined in the code.
Shader "Example/URPUnlitShaderBasic"
{
    // The properties block of the Unity shader. In this example this block is empty
    // because the output color is predefined in the fragment shader code.
    Properties
    { 
        _HeightMap("Height Map", 2D) = "white" {}
        _HeightFactor("Height Factor", Float) = 0.5
        _Offset("Offset", Float) = 0.2
    }

    // The SubShader block containing the Shader code. 
    SubShader
    {
        // SubShader Tags define when and under which conditions a SubShader block or
        // a pass is executed.
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS : NORMAL;
                float2 uvOS : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float2 uvHCS : TEXCOORD0;
                float3 normalHCS : TEXCOORD1;
            };

            sampler2D _HeightMap;
            float _HeightFactor;
            float _Offset;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                float3 pos = IN.positionOS.xyz;
                float4 color = tex2Dlod(_HeightMap, float4(IN.uvOS, 0, 0));
                pos.y += color.r * _HeightFactor;
                OUT.positionHCS = UnityObjectToClipPos(pos);
                OUT.uvHCS = IN.uvOS;
                OUT.normalHCS = IN.normalOS;
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float4 color = tex2Dlod(_HeightMap, float4(IN.uvHCS, 0, 0));
                float hL = tex2Dlod(_HeightMap, float4(IN.uvHCS - float2(_Offset, 0), 0, 0));
                float hR = tex2Dlod(_HeightMap, float4(IN.uvHCS + float2(_Offset, 0), 0, 0));
                float hD = tex2Dlod(_HeightMap, float4(IN.uvHCS - float2(0, _Offset), 0, 0));
                float hU = tex2Dlod(_HeightMap, float4(IN.uvHCS + float2(0, _Offset), 0, 0));
                float3 cL = normalize(float3(float2(1, 0), (hL - hR).x * _HeightFactor));
                float3 cD = normalize(float3(float2(0, 1), (hD - hU).x * _HeightFactor));
                float3 cnormal = normalize(cross(cL, cD).xzy);
                float diffuse = saturate(dot(_WorldSpaceLightPos0.xyz, cnormal));
                return float4(diffuse * color.xyz, 1);
            }
            ENDHLSL
        }
    }
}