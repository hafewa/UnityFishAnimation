            float4x4 rotate(float3 r, float4 d) // r=rotations axes
            {
                float cx, cy, cz, sx, sy, sz;
                sincos(r.x, sx, cx);
                sincos(r.y, sy, cy);
                sincos(r.z, sz, cz);
                return float4x4( cy*cz, -sz, sy, d.x,
                sz, cx*cz, -sx, d.y,
                -sy, sx, cx*cy, d.z,
                0, 0, 0, d.w );
            }

            float4 SideMove(float4 vertexPos, float _sideDisplaceFreq, float _sideDisplace, half maskedFactor)
			{
               
               //side to side movement
               vertexPos.x += -sin(_Time.y * _sideDisplaceFreq) * 0.001 * _sideDisplace * maskedFactor;
               return vertexPos;
			}

            float4 SpineYaw(float4 vertexPos, float spineYawLength, float spineYawFreq, half maskedFactor)
			{
               float4x4 rot_mat1;
               rot_mat1 = rotate(float3(0,sin(vertexPos.z * spineYawLength - _Time.y * spineYawFreq),0) * maskedFactor * 0.3,float4(0,0,0,1));
               vertexPos = mul(rot_mat1, vertexPos);
               return vertexPos;
			}

            float4 SpinePitch(float4 vertexPos, float spineYawLength, float spineYawFreq, half maskedFactor)
			{
               float4x4 rot_mat1;
               rot_mat1 = rotate(float3(sin(vertexPos.z * spineYawLength - _Time.y * spineYawFreq),0,0) * maskedFactor * 0.3,float4(0,0,0,1));
               vertexPos = mul(rot_mat1, vertexPos);
               return vertexPos;
			}

            float4 SpineRoll(float4 vertexPos, float rollLength, float rollFreq, half maskedFactor)
			{
               float4x4 rot_mat2;
               rot_mat2 = rotate(float3(0,0,sin(vertexPos.z *rollLength - _Time.y * rollFreq)) * 0.55 * maskedFactor ,float4(0,0,0,1));
               vertexPos = mul(rot_mat2, vertexPos);
               return vertexPos;
			}


            float4 wavedPos(float4 vertexPos, float _sideDisplaceFreq, float _sideDisplace, float rollLength, float rollFreq, float spineYawLength, float spineYawFreq, half maskedFactor)
			{
               //Roll rotation
               float4x4 rot_mat2;
               rot_mat2 = rotate(float3(0,0,sin(vertexPos.z * rollLength - _Time.y * rollFreq)) * clamp(maskedFactor, 0.2, 1) * 0.55 ,float4(0,0,0,1));
               vertexPos = mul(rot_mat2, vertexPos);

               //yaw along spine rotation
               float4x4 rot_mat1;
               rot_mat1 = rotate(float3(0,sin(vertexPos.z * spineYawLength - _Time.y * spineYawFreq),0) * maskedFactor * 0.3,float4(0,0,0,1));
               vertexPos = mul(rot_mat1, vertexPos);
            
               //side to side movement
               vertexPos.x += -sin(_Time.y * _sideDisplaceFreq) * 0.001 * _sideDisplace * maskedFactor;
               
               //Turning
              /* float4 desiredPos = vertexPos;
               float4x4 spineTurnMat, yawTurnMat;
               float turnBodyRange = smoothstep(_MaskZ,0.55, vertexPos.z+0.5); ;
               float turnVal = sin(vertexPos.z * (30)) * dirValue * -1;

               spineTurnMat = rotate(float3(0, 0 , 0),float4(0,0,0,1));
               desiredPos = mul(spineTurnMat, desiredPos);
    
               yawTurnMat = rotate(float3(0,dirValue,0),float4(0,0,0,1));
               desiredPos = mul(yawTurnMat, desiredPos);
    
               vertexPos = lerp(vertexPos, desiredPos, saturate(turnProgress * 0.75));*/
               return vertexPos;
			}