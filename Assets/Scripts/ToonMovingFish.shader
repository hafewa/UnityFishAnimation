// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/ToonMovingFish"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RimColor ("Rim Color Tint", Color) = (1, 1, 1, 1)
		_RimDistance("Rim Distance", Range(0, 1)) = 1
		_RimThreshold("Rim Threshold", Range(0, 1)) = 1
        [Space(5)]
        [Header(Debug DrawMode)]
        [Space(5)][Toggle(DEBUG_COLOR_MASK)]
        _DebugColorMask ("MASK DEBUG COLOR", Float) = 0
        [Toggle(DEBUG_COLOR_UV)]
        _DebugColorUv ("UV DEBUG COLOR", Float) = 0
        [Space(12)]
        [Header(Side To Side Movement)]
        [Space(5)]
        [Toggle(APPLY_SIDE_MOVE)]
        _ApplySideMove ("APPLY SIDE MOVE", Float) = 0
        _SideDisplaceFreq("SideDisplace Freq", Range(0,10)) = 5.5
        _SideDisplaceLength("SideDisplace Length", Range(0,30)) = 0
        [Space(12)]
        [Header(Roll Along Spine)]
        [Space(5)]
        [Toggle(APPLY_SPINE_ROLL)]
        _ApplySpineRoll ("APPLY SPINE ROLL", Float) = 0
        _RollLength("Roll Length", Range(0,60)) = 30
        _RollFreq("Roll Freq", Range(0,20)) = 5.5
        [Space(12)]
        [Header(Yaw Along Spine)]
        [Space(5)]
        [Toggle(APPLY_SPINE_PITCH)]
        _ApplySpinePitch ("Switch Yaw to Pitch", Float) = 0
        [Toggle(APPLY_SPINE_YAW)]
        _ApplySpineYaw ("APPLY SPINE YAW", Float) = 0
        _SpineYawLength("Spine Yaw Length", Range(0, 100)) = 30
        _SpineYawFreq("Spine Yaw Freq", Range(0, 20)) = 5.5
        [Space(12)]
        [Header(Animation Masking)]
        [Space(5)]
        _MaskZ("MaskZ", Range(-1, 1)) = 0
        _InvertScale("_InvertScale", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags {"LightMode"="ShadowCaster"}
 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"
            #include "FishAnimation.cginc"
            #pragma shader_feature APPLY_SIDE_MOVE
            #pragma shader_feature APPLY_SPINE_ROLL
            #pragma shader_feature APPLY_SPINE_YAW
            #pragma shader_feature APPLY_SPINE_PITCH

            float _SideDisplaceFreq;
            float _SideDisplaceLength;
            float _MaskZ;
            float _RollLength;
            float _RollFreq;
            float _SpineYawLength;
            float _SpineYawFreq;
            float _InvertScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float2 uv8 : TEXCOORD2;
            };

            struct v2f {
                V2F_SHADOW_CASTER;
            };
 
            v2f vert(appdata v)
            {
                half fac = smoothstep(-1/_InvertScale + _MaskZ/_InvertScale, 1/_InvertScale, v.vertex.z);
                #ifdef APPLY_SIDE_MOVE
                v.vertex = SideMove(v.vertex,_SideDisplaceFreq,_SideDisplaceLength,fac);
                #endif
                #ifdef APPLY_SPINE_ROLL
                v.vertex = SpineRoll(v.vertex,_RollLength,_RollFreq,fac);
                #endif
                #ifdef APPLY_SPINE_YAW
                v.vertex = SpineYaw(v.vertex,_SpineYawLength,_SpineYawFreq,fac);
                #elif APPLY_SPINE_PITCH
                v.vertex = SpinePitch(v.vertex,_SpineYawLength,_SpineYawFreq,fac);
                #endif
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }
 
            float4 frag(v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
	        #include "Lighting.cginc"
            #include "FishAnimation.cginc"
            #pragma shader_feature APPLY_SIDE_MOVE
            #pragma shader_feature APPLY_SPINE_ROLL
            #pragma shader_feature APPLY_SPINE_YAW
            #pragma shader_feature DEBUG_COLOR_MASK
            #pragma shader_feature DEBUG_COLOR_UV
            #pragma shader_feature APPLY_SPINE_PITCH

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float2 uv8 : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
                float3 worldPos : TEXCOORD2;
                float3 worldNormal : TEXCOORD3;
            };

           sampler2D _MainTex;
            float4 _MainTex_ST;

            float _RimDistance;
			float _RimThreshold;
			float4 _RimColor;

            float _SideDisplaceFreq;
            float _SideDisplaceLength;
            float _MaskZ;
            float _RollLength;
            float _RollFreq;
            float _SpineYawLength;
            float _SpineYawFreq;
            float _InvertScale;

            v2f vert (appdata v)
            {
                v2f o;
                half fac = smoothstep(-1/_InvertScale + _MaskZ/_InvertScale, 1/_InvertScale, v.vertex.z);
                #ifdef APPLY_SIDE_MOVE
                v.vertex = SideMove(v.vertex,_SideDisplaceFreq,_SideDisplaceLength,fac);
                #endif
                #ifdef APPLY_SPINE_ROLL
                v.vertex = SpineRoll(v.vertex,_RollLength,_RollFreq,fac);
                #endif
                #ifdef APPLY_SPINE_YAW
                v.vertex = SpineYaw(v.vertex,_SpineYawLength,_SpineYawFreq,fac);
                #elif APPLY_SPINE_PITCH
                v.vertex = SpinePitch(v.vertex,_SpineYawLength,_SpineYawFreq,fac);
                #endif
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                #ifdef DEBUG_COLOR_MASK
                o.color = fac;
                #elif DEBUG_COLOR_UV
                o.color = v.uv.x;
                #else
                o.color = v.color;
                #endif
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldNormal = normalize(i.worldNormal);
				float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

				float NdotL = dot(worldLightDir, worldNormal);
                float lightIntensity = smoothstep(0, 0.01, NdotL);
                fixed4 light = _LightColor0 * lightIntensity;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                float4 rimDot = 1 - dot(viewDir, worldNormal);
				fixed rimIntensity = rimDot * pow(NdotL, _RimThreshold);
				rimIntensity = smoothstep(_RimDistance - 0.01, _RimDistance + 0.01, rimIntensity);
                // apply fog
                fixed4 col = i.color * tex2D(_MainTex, i.uv);
                fixed3 lightsum = ((light + ambient + rimIntensity * rimDot * _RimColor) * col);
                UNITY_APPLY_FOG(i.fogCoord, lightsum);
                #ifdef DEBUG_COLOR_MASK
                return i.color;
                #endif
                return fixed4(lightsum, 1);
            }
            ENDCG
        }
    }
}
