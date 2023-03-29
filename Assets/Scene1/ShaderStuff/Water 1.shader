Shader "Custom/Water1"
{
    Properties
    {
        _Tint ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _WaterColor("WC", Color) = (1,1,1,1)
        FoamTex ("Foam", 2D) = "white" {}
        _Freq ("Frequency", Range (0,5)) = 3
        _Speed("Speed", Range(0,100)) = 10
        _Amp("Amplitude", Range(0,1)) = 0.5
        _ScrollX ("ScrollX", Range(-5,5)) = 1
        _ScrollY("ScrollY", Range(-5,5)) = 1
        _RampTex("Ramp Texture", 2D) = "white" {}
        _Brightness("Brightness", float) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf ToonRamp vertex:vert
        struct Input {
            float2 uv_MainTex;
            float3 vertColor;
        };

        float4 _Tint;
        float4 _WaterColor;
        float _Freq;
        float _Speed;
        float _Amp;
        float _ScrollX;
        float _ScrollY;
        sampler2D FoamTex;
        sampler2D _RampTex;
        float _Brightness;

        struct appdata {
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float4 texcoord: TEXCOORD0;
            float4 texcoord1: TEXCOORD1;
            float4 texcoord2: TEXCOORD2;
        };

        void vert(inout appdata v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            float t = _Time * _Speed;
            float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t * 2 + v.vertex.x * _Freq * 2) * _Amp;
            if (waveHeight > 0) {
                waveHeight = _Amp;
            }
            else {
                waveHeight = -_Amp;
            }
            
            v.vertex.y = v.vertex.y + waveHeight;
            v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
            o.vertColor = waveHeight + 2;
        }

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

        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) {
            _ScrollX *= _Time;
            _ScrollY *= _Time * 0.5;
            //float3 water = tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY)).rgb;
            float3 water = tex2D(_MainTex, IN.uv_MainTex).rgb;
            float3 foam = tex2D(FoamTex, IN.uv_MainTex + float2(_ScrollX/2, _ScrollY/2)).rgb;
            water.rgb = _WaterColor.rgb;
            o.Albedo = (water + foam)/2;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
