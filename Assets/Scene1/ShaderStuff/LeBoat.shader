Shader "Custom/LeBoat"
{
    Properties
    {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (0,0,0,1)
        _Outline("Outline Width", Range(.002,2)) = .005
        _RampTex("Ramp Texture", 2D) = "white" {}
        _Brightness("Brightness", float) = 1
        _Color("Color", Color) = (1,1,1,1)
        
    }
        SubShader
        {
            
            CGPROGRAM
            #pragma surface surf ToonRamp

            float4 _Color;
            sampler2D _MainTex;
            sampler2D _RampTex;
            float _Brightness;
            

            struct Input
            {
                float2 uv_MainTex;
    
            };

            struct appdata {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };

            half4 LightingToonRamp(SurfaceOutput s, half3 lightDir, fixed atten) {
                //half3 h = normalize(lightDir + viewDir);

                half diff = max(0, dot(s.Normal, lightDir));
                float h = diff * 0.5 + 0.5;
                float2 rh = h;
                float3 ramp = tex2D(_RampTex, rh).rgb;
                //float nh = max(0, dot(s.Normal, h));
                //float spec = pow(nh, 48.0);

                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * (ramp) * _Brightness;
                c.a = s.Alpha;
                return c;
            }

            void surf(Input IN, inout SurfaceOutput o)
            {

            o.Albedo = _Color.rgb;

            }
            ENDCG

            Pass{
                Cull Front
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                struct appdata {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };
                struct v2f {
                    float4 pos : SV_POSITION;
                    float4 color : COLOR;


                };

                float _Outline;
                float4 _OutlineColor;
                
                
                
                
                v2f vert(appdata v) {
                    v2f o;
                    //v.vertex.xyz += v.normal * _ExtrudeAmount;
                    
                    o.pos = UnityObjectToClipPos(v.vertex);
                    float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                    float2 offset = TransformViewToProjection(norm.xy);

                    o.pos.xy += offset * o.pos.z * _Outline;
                    o.color = _OutlineColor;
                    
                    return o;
                }
                fixed4 frag(v2f i) : SV_Target{
                    return i.color;
                }
                ENDCG
            }
        }
    FallBack "Diffuse"
}
