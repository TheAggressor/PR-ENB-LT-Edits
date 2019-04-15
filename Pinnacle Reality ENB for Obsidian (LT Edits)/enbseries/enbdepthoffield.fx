/* /////////////////////////////////////////////////////////
//                ENBSeries effect file                //
//         visit http://enbdev.com for updates         //
//       Copyright (c) 2007-2015 Boris Vorontsov       //
//----------------------ENB PRESET---------------------//
			MM"""""""`YM MM"""""""`MM M""""""""M 
			MM  mmmmm  M MM  mmmm,  M Mmmm  mmmM 
			M'        .M M'        .M MMMM  MMMM 
			MM  MMMMMMMM MM  MMMb. "M MMMM  MMMM 
			MM  MMMMMMMM MM  MMMMM  M MMMM  MMMM 
			MM  MMMMMMMM MM  MMMMM  M MMMM  MMMM 
			MMMMMMMMMMMM MMMMMMMMMMMM MMMMMMMMMM 
https://www.nexusmods.com/skyrimspecialedition/mods/4743                                
//-----------------------CREDITS-----------------------//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ENBSeries Skyrim SE dx11 sm5 effect file
// visit facebook.com/MartyMcModding for news/updates
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Advanced Depth of Field & SSAO 2.1f by Marty McFly
// 		  Do not redistribute without credits!         //
// Private for testing.                                //
// Copyright (c) 2008-2017 Marty McFly				   //
// Boris: For ENBSeries and his knowledge and codes    //
// McFly: Original author of the DOF code              //
// Matso: Original author of the Chromatic Aberration  //
// L00 :  Shader Setup, Presets and Settings,          //
//        Port and Modification of  Shaders            //
//        and author of this file                      //
/////////////////////////////////////////////////////////
//             			PRE					           //
//-----------------------------------------------------//
//              DEPTH OF FIELD SHADER SUITE            //
//                        0.0.8                        //

/////////////////////////////////////////////////////////
//               SETTINGS & GUI                        //
///////////////////////////////////////////////////////// */

//UI vars

//#define	fADOF_RenderResolutionMult  1.0


#define bADOF_AutofocusEnable 		1
#define fADOF_AutofocusCenter 		float2(0.5,0.5)
#define	iADOF_AutofocusSamples 		5
#define	fADOF_AutofocusRadius 		0.02
#define	fADOF_ManualfocusDepth 		0.05
#define bADOF_ShapeWeightEnable 	1


#define	fADOF_NearBlurMult 			-1.0+fADOF_FarBlurCurve //1.0
#define	fADOF_FarBlurMult 			1.0*fADOF_FarBlurCurve
#define	fADOF_NearBlurCurve 		1.0+fADOF_FarBlurCurve

#define	fADOF_InfiniteFocus 		0.03
#define	iADOF_ShapeVertices 		6
//#define	iADOF_ShapeQuality 			6
#define	fADOF_ShapeCurvatureAmount	0.7
#define	fADOF_ShapeRotation 128
#define	fADOF_ShapeAnamorphRatio	0.9

#define	fADOF_SmootheningAmount		0.35
#define	fADOF_ShapeWeightCurve		10.0
#define	fADOF_ShapeWeightAmount		0.25

#define fADOF_FarBlurCurve 			fLensAperture
#define fADOF_ShapeRadius 			fBokehAperture/(fLensAperture+0.65)

//GUI
int		iQuality			<string UIName="Quality";string UIWidget="quality";int UIMin=-1;int UIMax=4;> = {1};
bool	bMFocus				<string UIName="Manual Focus (Click on Focus Point)";> = {false};	

float	fLensAperture		<string UIName="Aperture.";string UIWidget="Spinner";float UIStep=0.05;float UIMin=0.10;float UIMax=16.0;> = {1.0};
float	fBokehAperture		<string UIName="Scale";string UIWidget="Spinner";float UIStep=0.1;float UIMin=0.1;float UIMax=50.0;> = {6.0};
float	fADOF_BokehCurve	<string UIName="Bokeh";string UIWidget="Spinner";float UIStep=0.1;float UIMin=0.1;float UIMax=20.0;> = {1.5};
float	fChromaPower		<string UIName="Chroma";string UIWidget="Spinner";float UIStep=1.0;float UIMin=-20.00;float UIMax=20.00;> = {3.0};

/* //AO
float Empty_Row0
<string UIName="                                        ";string UIWidget="spinner";float UIMin=0.0;float UIMax=0.0;
> = {0.0};
float Empty_Row01 			<string UIName="                      Ambiant Occlusion Settings";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0; float UIStep=1.0;> = {0.0};


 float	fMXAOSampleRadius	        < string UIName="AO: Radius";		        string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.0;	float UIMax=10.0;	> = {2.5};
 
 
 float	fMXAOAmbientOcclusionPower	< string UIName="AO: Curve";		                string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.05;	float UIMax=5.0;	> = {1.0};
 float	fMXAOAmbientOcclusionAmount	< string UIName="AO: Amount";		                string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.0;	float UIMax=5.0;	> = {2.0};
  */

#define fMXAOSampleRadius 8.0
#define fMXAOAmbientOcclusionPower 0.65
#define fMXAOAmbientOcclusionAmount 0.75


#define iMXAOSampleCount 1 //12
#define fMXAONormalBias 0.05
#define fMXAOAmbientOcclusionLuminance 1.2
#define iMXAOBlurSteps 0 //1
#define fMXAOBlurSharpness 0.0 //1.0
#define fMXAOFadeStart 0.0 //0.01
#define fMXAOFadeEnd 0.0 //0.05 //FOR SKYRIM SE ONLY
#define bMXAOShowAO 0

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//external enb parameters, do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	Timer; 			//x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4	ScreenSize; 		//x = Width, y = 1/Width, z = aspect, w = 1/aspect, aspect is Width/Height
float	AdaptiveQuality;	//changes in range 0..1, 0 means full quality, 1 lowest dynamic quality (0.33, 0.66 are limits for quality levels)
float4	Weather;		//x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours. Weather index is value from weather ini file, for example WEATHER002 means index==2, but index==0 means that weather not captured.
float4	TimeOfDay1;		//x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4	TimeOfDay2;		//x = dusk, y = night. Interpolators range from 0..1
float	ENightDayFactor;	//changes in range 0..1, 0 means that night time, 1 - day time
float	EInteriorFactor;	//changes 0 or 1. 0 means that exterior, 1 - interior

#define PixelSize 		float2(ScreenSize.y,ScreenSize.y*ScreenSize.z)
uniform float4 DepthParameters  = float4(1.0,3000.0,-2999.0f,0.0);//x = near plane, y = far plane, z = -(y-x), w = unused
extern float fWaterLevel = 1.0;
#define DOF(sd,sf)		fADOF_ShapeRadius * smoothstep(fADOF_FarBlurMult * tempF1.y, fADOF_NearBlurMult * tempF1.z, abs(sd - sf))
// Chromatic aberration parameters
float3 fvChroma = float3(0.9995, 1.000, 1.0005);// displacement scales of red, green and blue respectively
#define fBaseRadius 0.9							// below this radius the effect is less visible
#define fFalloffRadius 1.8						// over this radius the effect is max
#define CHROMA_POW		32.0								// the bigger the value, the more visible chomatic aberration effect in DoF
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//external enb debugging parameters for shader programmers, do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	tempF1; 		//0,1,2,3
float4	tempF2; 		//5,6,7,8
float4	tempF3; 		//9,0
float4	tempInfo1; 		//float4(cursorpos.xy 0~1,isshaderwindowopen, mouse buttons)
float4	tempInfo2;		//float4(cursorpos.xy prev left mouse button click, cursorpos.xy prev right mouse button click)

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//mod parameters, do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4			DofParameters;		//z = ApertureTime multiplied by time elapsed, w = FocusingTime multiplied by time elapsed
Texture2D		TextureCurrent; 	//current frame focus depth or aperture. unused in dof computation
Texture2D		TexturePrevious; 	//previous frame focus depth or aperture. unused in dof computation
Texture2D		TextureOriginal; 	//color R16B16G16A16 64 bit hdr format
Texture2D		TextureColor; 		//color which is output of previous technique (except when drawed to temporary render target), R16B16G16A16 64 bit hdr format
Texture2D		TextureDepth; 		//scene depth R32F 32 bit hdr format
Texture2D		TextureFocus; 		//this frame focus 1*1 R32F hdr red channel only. computed in PS_Focus
Texture2D		TextureAperture; 	//this frame aperture 1*1 R32F hdr red channel only. computed in PS_Aperture
Texture2D		TextureAdaptation;	//previous frame vanilla or enb adaptation 1*1 R32F hdr red channel only. adaptation computed after depth of field and it's kinda "average" brightness of screen!!!
//temporary textures which can be set as render target for techniques via annotations like <string RenderTarget="RenderTargetRGBA32";>
Texture2D		RenderTargetRGBA32; 	//R8G8B8A8 32 bit ldr format
Texture2D		RenderTargetRGBA64; 	//R16B16G16A16 64 bit ldr format
Texture2D		RenderTargetRGBA64F; 	//R16B16G16A16F 64 bit hdr format
Texture2D		RenderTargetR16F; 	//R16F 16 bit hdr format with red channel only
Texture2D		RenderTargetR32F; 	//R32F 32 bit hdr format with red channel only
Texture2D		RenderTargetRGB32F; 	//32 bit hdr format without alpha

SamplerState		Sampler0
{
	Filter = MIN_MAG_MIP_POINT;
	AddressU = Clamp;
	AddressV = Clamp;
};

SamplerState		Sampler1
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};

SamplerState		Sampler2
{
	Filter = MIN_MAG_MIP_POINT;
	AddressU = Wrap;
	AddressV = Wrap;
};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Vertex Shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void VS_DOF(in float3 inpos : POSITION, inout float2 txcoord0 : TEXCOORD0, out float4 outpos : SV_POSITION)
{
	outpos = float4(inpos.xyz,1.0);
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Functions
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float GetLinearDepth(float2 coords)
{
	float depth = TextureDepth.SampleLevel(Sampler1, coords.xy,0).x;
	depth *= rcp(DepthParameters.y + depth * DepthParameters.z);
	return depth;
}

float3 GetPosition(float2 coords)
{
        return float3(coords.xy*2.0-1.0,1.0)*GetLinearDepth(coords.xy)*DepthParameters.y;
}

float GetBayerFromCoordLevel(float2 pixelpos, int maxLevel)
{
	float finalBayer = 0.0;

	for(float i = 1-maxLevel; i<= 0; i++)
	{
		float bayerSize = exp2(i);
	        float2 bayerCoord = floor(pixelpos * bayerSize) % 2.0;
		float bayer = 2.0 * bayerCoord.x - 4.0 * bayerCoord.x * bayerCoord.y + 3.0 * bayerCoord.y;
		finalBayer += exp2(2.0*(i+maxLevel))* bayer;
	}

	float finalDivisor = 4.0 * exp2(2.0 * maxLevel)- 4.0;
	return finalBayer/ finalDivisor + 1.0/exp2(2.0 * maxLevel);
}

float GetCoC(float2 texcoord)
{
	float	scenedepth	= GetLinearDepth(texcoord.xy);
	float	scenefocus	= TextureFocus.Sample(Sampler0, texcoord.xy).x;
	float   scenecoc 	= 0.0;

	scenefocus = smoothstep(0.0,fADOF_InfiniteFocus,scenefocus);
	scenedepth = smoothstep(0.0,fADOF_InfiniteFocus,scenedepth);

	float farBlurDepth = scenefocus*pow(4.0,fADOF_FarBlurCurve);

	if(scenedepth < scenefocus)
	{
		scenecoc = (scenedepth - scenefocus) / scenefocus;
		scenecoc *= fADOF_NearBlurMult;
	}
	else
	{
		scenecoc=(scenedepth - scenefocus)/(farBlurDepth - scenefocus);
		scenecoc *= fADOF_FarBlurMult;
		scenecoc=saturate(scenecoc);
	}

	scenecoc = (scenedepth < 0.00000001) ? 0.0 : scenecoc; //first person models, that epsilon is handpicked, do not change
	scenecoc = saturate(scenecoc * 0.5 + 0.5);
	return scenecoc;
}


float3 BokehBlur(Texture2D colortex,
                 float2 coords,
                 float discRadius,
                 float centerDepth,
                 int nQuality,
                 int nVertices,
                 float BokehCurve)
{
	float4 res 			= float4(pow(colortex.Sample(Sampler1, coords.xy).xyz,BokehCurve),1.0);
	float ringIncrement		= rcp(nQuality);

        
                float2 discRadiusScaled	= discRadius*float2(fADOF_ShapeAnamorphRatio,ScreenSize.z)*0.0006*ringIncrement;
   

        float2 currentVertex,nextVertex,matrixVector;
	sincos(radians(fADOF_ShapeRotation),currentVertex.y,currentVertex.x);
	sincos(6.2831853 / nVertices,matrixVector.x,matrixVector.y);

	float2x2 rotMatrix = float2x2(matrixVector.y,-matrixVector.x,matrixVector.x,matrixVector.y);

        #if(bADOF_ShapeWeightEnable != 0)
               res.w *= saturate(1.0f-fADOF_ShapeWeightAmount*nQuality);
               res.xyz *= res.w;
	#endif

        

	[fastopt]
	for(float iRings = 1; iRings <= nQuality && iRings <= 25; iRings++)
	{
		[fastopt]
		for (int iVertices = 1; iVertices <= nVertices && iVertices <= 9; iVertices++)
		{
			nextVertex = mul(currentVertex.xy, rotMatrix);

			[fastopt]
			for (float iSamplesPerRing = 0; iSamplesPerRing < iRings && iSamplesPerRing < 25; iSamplesPerRing++)
			{
				float2 sampleOffset = lerp(currentVertex,nextVertex,iSamplesPerRing/iRings);
				sampleOffset *= lerp(1.0,rsqrt(dot(sampleOffset,sampleOffset)),fADOF_ShapeCurvatureAmount);

				
				        float4 tap = colortex.SampleLevel(Sampler1, coords.xy + (sampleOffset.xy * discRadiusScaled) * iRings,0);
				
						tap.w = (centerDepth > 0.5) ? saturate(abs(tap.w*2.0-1.0)-iRings*ringIncrement*abs(centerDepth*2.0-1.0)) : 1.0; //I believe this is almost perfect.
   
                             


				#if(bADOF_ShapeWeightEnable != 0)
				tap.w *= lerp(1.0,pow(iRings*ringIncrement,fADOF_ShapeWeightCurve),fADOF_ShapeWeightAmount);
				#endif

				res.xyz += pow(tap.xyz,BokehCurve)*tap.w;
				res.w += tap.w;
			}

			currentVertex = nextVertex;
		}
	}
        res.xyz = pow(max(0.0,res.xyz/res.w),rcp(BokehCurve));
	return res.xyz;
}

float4 ChromaticAberration(float2 tex)
{
	float d = distance(tex, float2(0.5, 0.5));
	float f = smoothstep(fBaseRadius, fFalloffRadius, d);
	float3 chroma = pow(f + fvChroma, fChromaPower);
	
	float2 tr = ((2.0 * tex - 1.0) * chroma.r) * 0.5 + 0.5;
	float2 tg = ((2.0 * tex - 1.0) * chroma.g) * 0.5 + 0.5;
	float2 tb = ((2.0 * tex - 1.0) * chroma.b) * 0.5 + 0.5;
	
	float3 color = float3(TextureColor.Sample(Sampler0, tr).r, TextureColor.Sample(Sampler0, tg).g, TextureColor.Sample(Sampler0, tb).b) * (1.0 - f);
	
	return float4(color, 1.0);
}


float4 ChromaticAberration(float2 tex, float outOfFocus)
{
	float d = distance(tex, float2(0.5, 0.5));
	float f = smoothstep(fBaseRadius, fFalloffRadius, d);
	float3 chroma = pow(f + fvChroma, CHROMA_POW * outOfFocus * fChromaPower);

	float2 tr = ((2.0 * tex - 1.0) * chroma.r) * 0.5 + 0.5;
	float2 tg = ((2.0 * tex - 1.0) * chroma.g) * 0.5 + 0.5;
	float2 tb = ((2.0 * tex - 1.0) * chroma.b) * 0.5 + 0.5;
	
	float3 color = float3(TextureColor.Sample(Sampler0, tr).r, TextureColor.Sample(Sampler0, tg).g, TextureColor.Sample(Sampler0, tb).b) * (1.0 - outOfFocus);
	
	return float4(color, 1.0);
}

float3 GetNormalFromDepth(float2 coords)
{
	float3 offs = float3(PixelSize.xy,0);

	float3 f 	 =       GetPosition(coords.xy);
	float3 d_dx1 	 = - f + GetPosition(coords.xy + offs.xz);
	float3 d_dx2 	 =   f - GetPosition(coords.xy - offs.xz);
	float3 d_dy1 	 = - f + GetPosition(coords.xy + offs.zy);
	float3 d_dy2 	 =   f - GetPosition(coords.xy - offs.zy);

	d_dx1 = lerp(d_dx1, d_dx2, abs(d_dx1.z) > abs(d_dx2.z));
	d_dy1 = lerp(d_dy1, d_dy2, abs(d_dy1.z) > abs(d_dy2.z));

	return normalize(cross(d_dy1,d_dx1));
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float GetBlurWeight(float O, float z, float z0)
{
        float DeltaZ = abs(z-z0) * DepthParameters.y * fMXAOBlurSharpness;
        float DeltaO = O/(iMXAOBlurSteps+1.0);

        return exp2(-0.5*DeltaO*DeltaO-DeltaZ*DeltaZ);
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


float3 CombineAO(float3 color, float mxao, float2 texcoord, bool outputAO)
{
        mxao    = saturate(1.0 - mxao);
        mxao    = pow(mxao,fMXAOAmbientOcclusionPower);
        mxao    = lerp(mxao, 1.0, (1 - outputAO) * pow(saturate(dot(color.xyz,fMXAOAmbientOcclusionLuminance)),2.0));
        mxao    = lerp(mxao,1.0,smoothstep(fMXAOFadeStart,fMXAOFadeEnd,GetLinearDepth(texcoord.xy)));

        color.xyz = (outputAO) ? mxao : color.xyz * mxao;
        return color;
}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Pixel Shaders
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/// AMBIANT OCCLUSION

float4 PS_AO_NormalTexture(float2 texcoord : TEXCOORD0, float4 vpos : SV_POSITION) : SV_Target
{
        int level = round((8*1.4142) * pow(iMXAOSampleCount,-0.7071) + 1.4142);
        float AOjitter = GetBayerFromCoordLevel(vpos.xy,level);
        float3 normal = GetNormalFromDepth(texcoord.xy);
        return float4(normal*0.5+0.5,AOjitter);
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float GetMXAO( float2 scaledcoord,
               float3 normal,
               float3 position,
               float nSamples,
               float2 currentVector,
               float fNegInvR2,
               float radiusJitter,
               float sampleRadius)
{
	float AO = 0.0;
        float2 currentOffset = 0.0;

	[loop]
	for(int iSample=0; iSample < nSamples; iSample++)
	{
                currentOffset.xy = scaledcoord.xy + currentVector.xy * (iSample + radiusJitter);
                currentOffset.y *= ScreenSize.z;

		float3 occlVec 		= -position + GetPosition(currentOffset);
		float  occlDistanceRcp 	= rsqrt(dot(occlVec,occlVec));

		AO += saturate(1.0 + fNegInvR2/occlDistanceRcp)  * saturate(dot(occlVec, normal)*occlDistanceRcp - fMXAONormalBias);
                currentVector = mul(currentVector.xy, float2x2(0.575,0.81815,-0.81815,0.575));
	}

	return saturate(fMXAOAmbientOcclusionAmount * AO/(0.15*(1.0-fMXAONormalBias)*nSamples*sqrt(sampleRadius)));
}

float4	PS_AO_Gen(float2 texcoord : TEXCOORD0, float4 vpos : SV_POSITION) : SV_Target
{
        float4 normalSample = RenderTargetRGBA32.Sample(Sampler1,texcoord.xy);
        float3 ScreenSpaceNormals = normalSample.xyz * 2.0 - 1.0;
        float3 ScreenSpacePosition = GetPosition(texcoord.xy);

        float scenedepth = ScreenSpacePosition.z / DepthParameters.y;

        clip(fMXAOFadeEnd-scenedepth);
        ScreenSpacePosition += ScreenSpaceNormals * scenedepth;

        float SampleRadiusScaled  = 0.2*fMXAOSampleRadius*fMXAOSampleRadius / (iMXAOSampleCount * ScreenSpacePosition.z);
        float mipFactor = SampleRadiusScaled * 300.0 * sqrt(iMXAOSampleCount);

        float2 currentVector;
        sincos(2.0*3.14159274*normalSample.w, currentVector.y, currentVector.x);
        static const float fNegInvR2 = -1.0/(fMXAOSampleRadius*fMXAOSampleRadius);
        currentVector *= SampleRadiusScaled;

        texcoord.y /= ScreenSize.z;

        float MXAO =  GetMXAO(texcoord,
                      ScreenSpaceNormals,
                      ScreenSpacePosition,
                      iMXAOSampleCount,
                      currentVector,
                      fNegInvR2,
                      normalSample.w,
                      fMXAOSampleRadius);

        MXAO -= ddx(MXAO)*(fmod(vpos.x-0.5,2.0)-0.5) * 0.666;
        MXAO -= ddy(MXAO)*(fmod(vpos.y-0.5,2.0)-0.5) * 0.666;

        return float4(scenedepth.xxx,MXAO);
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 GetBlurredAO( float2 texcoord, float2 axis, int nSteps)
{
        float4 centersample,tempsample;
        float centerkey,tempkey;
        float2 blurcoord = 0.0;
        float totalweight = 0.5,tempweight;

        centersample = TextureColor.Sample(Sampler1, texcoord.xy);
        centerkey = centersample.x;
        centersample.w *= totalweight;

        [loop]
	for(int orientation=-1;orientation<=1; orientation+=2)
	{
		[loop]
		for(float iStep = 1.0; iStep <= nSteps; iStep++)
		{
			blurcoord.xy 	= (2.0 * iStep - 0.5) * orientation * axis * PixelSize.xy + texcoord.xy;
                        tempsample = TextureColor.SampleLevel(Sampler1, blurcoord.xy,0);
                        float tempkey = tempsample.x;

                        tempweight = GetBlurWeight(iStep, tempkey, centerkey);
                        centersample.w += tempsample.w * tempweight;
                        totalweight += tempweight;
                }
        }

        centersample.w /= totalweight;
        return centersample;
}

float4 PS_AO_Blur1(float2 texcoord : TEXCOORD0) : SV_Target
{
        return GetBlurredAO(texcoord.xy, float2(1.0,0.0), iMXAOBlurSteps);
}

float4 PS_AO_Blur2(float2 texcoord : TEXCOORD0) : SV_Target
{
        return GetBlurredAO(texcoord.xy, float2(0.0,1.0), iMXAOBlurSteps);
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 PS_AO_Combine(float2 texcoord : TEXCOORD0, uniform bool showAO) : SV_Target
{
	float ao 		= RenderTargetRGBA32.Sample(Sampler1, texcoord.xy).w;
        float4 color            = TextureOriginal.Sample(Sampler1, texcoord.xy);

        color.xyz = CombineAO(color.xyz, ao, texcoord, showAO);

        return color;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//DEPTH OF FIELD

//? -> 1x1 R32F
float4	PS_Aperture(float2 texcoord : TEXCOORD0) : SV_Target
{
	//as I don't use aperture and deleting the technique causes weird things to happen, don't waste resources :v
	return 1;
}

//fullres -> 16x16 R32F //Slight modification from Looping to adapt Wolrajh focus point.
float4	PS_ReadFocus(float2 texcoord : TEXCOORD0) : SV_Target
{
	float scenefocus 	= fADOF_ManualfocusDepth;
	float2 coords 		= 0.0;

	if(bADOF_AutofocusEnable != 0)
	{
		scenefocus = GetLinearDepth(fADOF_AutofocusCenter.xy);
		float2 offsetVector = float2(1.0,0.0) * fADOF_AutofocusRadius;
		float Alpha = 6.2831853 / iADOF_AutofocusSamples;
		float2x2 rotMatrix = float2x2(cos(Alpha),-sin(Alpha),sin(Alpha),cos(Alpha));

		for(int i=0; i<iADOF_AutofocusSamples; i++)
		{
			float2 currentOffset = fADOF_AutofocusCenter + offsetVector.xy;
			scenefocus += GetLinearDepth(currentOffset);
			offsetVector = mul(offsetVector,rotMatrix);
		}

		scenefocus /= iADOF_AutofocusSamples;
	}
	if (bMFocus == true)
	{
		
		scenefocus = GetLinearDepth(tempInfo2.xy);
	
	}
	scenefocus = saturate(scenefocus);
	return scenefocus;
}

//16x16 -> 1x1 R32F  ///Modified to always interpolate
float4	PS_Focus(float2 texcoord : TEXCOORD0) : SV_Target
{
	float prevFocus = TexturePrevious.Sample(Sampler1, texcoord.xy).x;
	float currFocus = TextureCurrent.Sample(Sampler1, texcoord.xy).x;
	
	float res = 0.0f;
	res = lerp(prevFocus, currFocus, DofParameters.w);
	if(prevFocus < currFocus) res = lerp(prevFocus,currFocus,DofParameters.w*lerp(0.03f,0.35f,saturate(currFocus/prevFocus)) / pow(2.5f,fADOF_FarBlurCurve));
	res = saturate(res);
	return res;
	return 0.0f;
}

float4	PS_CoC(float2 texcoord : TEXCOORD0) : SV_Target
{
	float4 res 		= TextureColor.Sample(Sampler1, texcoord.xy);
	float scenecoc 		= GetCoC(texcoord.xy);
	res.w = scenecoc;
	return res;
}

float4	PS_DoF_Main(float2 texcoord : TEXCOORD0) : SV_Target
{
	
	float fQualityMulti;
	float fADOF_RenderResolutionMult;
	float iADOF_ShapeQuality;
	
	if (iQuality==2) { 
		fADOF_RenderResolutionMult = 0.33;
		iADOF_ShapeQuality = 4;
	}
	if (iQuality==1) {
		fADOF_RenderResolutionMult = 0.5;
		iADOF_ShapeQuality = 5;
	}
	if (iQuality==0) {
		fADOF_RenderResolutionMult = 0.75;
		iADOF_ShapeQuality = 6;
	}
	if (iQuality==-1) {
		fADOF_RenderResolutionMult = 1.0;
		iADOF_ShapeQuality = 7;
	}
	
	float2 scaledcoord = texcoord.xy / fADOF_RenderResolutionMult;
        clip(!all(saturate(-scaledcoord * scaledcoord + scaledcoord + 0.01)) ? -1:1); //0.01 epsilon to prevent border issues with AO.

	float4 scenecolor = TextureColor.Sample(Sampler1, scaledcoord.xy);

	float centerDepth = scenecolor.w;
	float blurAmount = abs(centerDepth * 2.0 - 1.0);
	float discRadius = blurAmount * fADOF_ShapeRadius;

       
	       discRadius*=(centerDepth < 0.5) ? (1.0 / max(fADOF_NearBlurCurve * 2.0, 1.0)) : 1.0;
        

        #if(ENABLE_AO_TECHNIQUES == 0)
                //AO remains in those clipped parts and due to TAA (I suppose)
                //it bleeds into color at the end, even though this shouldn't be possible.
                //Visible at night, scattered white pixels at blur-focus transition
                clip((discRadius<1.0)?-1:1);
        #endif

        #if(iADOF_PostBlurMode == 0)
                int ringCount = round(lerp(1.0,(float)iADOF_ShapeQuality,blurAmount));
        #elif(iADOF_PostBlurMode == 1)
                //new, less obvious quality jumps. blur is heavier now but the 2nd bokeh pass instead of Gaussian
                //makes low qualities look higher quality so the user can lower the quality, gaining fps again.
                int ringCount = lerp(1.0, iADOF_ShapeQuality, saturate(0.333 * discRadius / iADOF_ShapeQuality));
        #endif

	scenecolor.xyz = BokehBlur(TextureColor,scaledcoord.xy, discRadius, centerDepth, ringCount, iADOF_ShapeVertices, fADOF_BokehCurve);
	scenecolor.w = centerDepth;

	return scenecolor;
}

float4	PS_DoF_Combine(float2 texcoord : TEXCOORD0,  uniform bool applyAO) : SV_Target
{
	float fQualityMulti;
	float fADOF_RenderResolutionMult;
	if (iQuality==2) fADOF_RenderResolutionMult = 0.33;
	if (iQuality==1) fADOF_RenderResolutionMult = 0.5;
	if (iQuality==0) fADOF_RenderResolutionMult = 0.75;
	if (iQuality==-1) fADOF_RenderResolutionMult = 1.0;
	
	float4 blurredcolor 		= TextureColor.Sample(Sampler1, texcoord.xy*fADOF_RenderResolutionMult);
	float4 unblurredcolor		= TextureOriginal.Sample(Sampler1, texcoord.xy);
	float4 scenecolor			= ChromaticAberration(texcoord.xy);
	
	
	float centerDepth			= GetCoC(texcoord.xy);

	unblurredcolor.xyz = (applyAO) ? CombineAO(unblurredcolor.xyz,  RenderTargetRGBA32.Sample(Sampler1, texcoord.xy).w, texcoord.xy, 0) : unblurredcolor.xyz;
	
	float discRadius = abs(centerDepth * 2.0 - 1.0) * fADOF_ShapeRadius;
	discRadius*=(centerDepth < 0.5) ? (1.0 / max(fADOF_NearBlurCurve * 2.0, 1.0)) : 1.0;

	//1.0 + 0.05 epsilon because discard at 1.0 in PS_DoF_Main
	scenecolor.xyz = lerp(blurredcolor.xyz, unblurredcolor.xyz,smoothstep(4.0,1.05,discRadius));

	scenecolor.w = centerDepth;
	return scenecolor;
}

float4	PS_DoF_Smoothen(float2 texcoord : TEXCOORD0) : SV_Target
{
	float4 scenecolor 		= TextureColor.Sample(Sampler1, texcoord.xy);

	float centerDepth = scenecolor.w;
	float blurAmount = abs(centerDepth * 2.0 - 1.0);
	blurAmount = smoothstep(0.0,0.15,blurAmount)*fADOF_SmootheningAmount;

	scenecolor = 0.0;


	float offsets[5] = {-3.2307692308, -1.3846153846, 0.0, 1.3846153846, 3.2307692308};
	float weights[3] = {0.2270270270, 0.3162162162, 0.0702702703};

	float chromaamount = 1.3;

	for(int x=-2; x<=2; x++)
	for(int y=-2; y<=2; y++)
	{
		float2 coord = float2(x,y);
		float2 actualoffset = float2(offsets[x+2],offsets[abs(y+2)])*blurAmount*PixelSize.xy;
		float weight = weights[abs(x)] * weights[abs(y)];
		scenecolor.xyz += TextureColor.SampleLevel(Sampler1, texcoord.xy + actualoffset,0).xyz * weight;
		scenecolor.w += weight;
	}
	scenecolor.xyz /= scenecolor.w;
	return scenecolor;

}

float4 PS_ProcessPass_Chroma(float2 texcoord : TEXCOORD0) : SV_Target
{
	float2 coord = texcoord.xy;
	float4 scenecolor = ChromaticAberration(coord.xy);
	scenecolor.a = 1.0;
	return scenecolor;
}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Techniques
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//write aperture with time factor, this is always first technique
technique11 Aperture
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_Aperture()));
	}
}

//compute focus from depth of screen and may be brightness, this is always second technique
technique11 ReadFocus
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_ReadFocus()));
	}
}

//write focus with time factor, this is always third technique
technique11 Focus
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_Focus()));
	}
}

technique11 DOF <string UIName="PRE.DOF";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_ProcessPass_Chroma()));
	}
}

technique11 DOF1
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_CoC()));
	}
}

technique11 DOF2
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Main()));
	}
}

technique11 DOF3
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Combine(0)));
	}
}

technique11 DOF4
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Smoothen()));
	}
}

/* // AO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

technique11 DOFAO <string UIName="PRE:AO&DOF"; string RenderTarget="RenderTargetRGBA32";>
{
        pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_AO_NormalTexture()));
	}
}

technique11 DOFAO1
{
        pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_AO_Gen()));
	}
}

technique11 DOFAO2
{
        pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_AO_Blur1()));
	}
}

technique11 DOFAO3 <string RenderTarget="RenderTargetRGBA32";>
{
        pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_AO_Blur2()));
	}
}
technique11 DOFAO4
{
        pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_AO_Combine(bMXAOShowAO )));
	}
}
// DOF ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

technique11 DOFAO5
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_ProcessPass_Chroma()));
	}
}

technique11 DOFAO6
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_CoC()));
	}
}

technique11 DOFAO7
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Main()));
	}
}

technique11 DOFAO8
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Combine(1)));
	}
}



technique11 DOFAO9
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Smoothen()));
	}
} */