Shader "Custom/ToonShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _RampTex("Ramp Texture", 2D) = "white" {}
        _Brightness("Brightness", float) = 1

    }
        SubShader
    {

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf ToonRamp


        float4 _Color;
        sampler2D _RampTex;
        float _Brightness;

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

        struct Input
        {
            float2 uv_MainTex;
        };





        void surf(Input IN, inout SurfaceOutput o)
        {

            o.Albedo = _Color.rgb;

        }
        ENDCG
    }
        FallBack "Diffuse"
}
