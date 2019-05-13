using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderEffectBloom : MonoBehaviour
{

    public Shader BloomShader; // Capture the shader we'll be messing with
    [Range(0.0f, 40.0f)] // Clamp the bloom effect so my computer doesn't explode
    public float BloomFactor; // Allow the script and the slider to affect the bloom
    private Material screenMat; // Capture the material to put in front of the camera

    Material ScreenMat // A getter function for the material
    {
        get
        {
            if (screenMat == null)
            {
                screenMat = new Material(BloomShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return screenMat;
        }
    }


    void Start()
    {
        if (!SystemInfo.supportsImageEffects) // make sure the computer can handle this bizz
        {
            enabled = false;
            return;
        }

       /* if (!BloomShader && !BloomShader.isSupported)
        {
            enabled = false;
        }*/
       
    }

    public void sliderBloom(float newVal) // Allow for slider magic
    {
        BloomFactor = newVal;
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (BloomShader != null)
        {

            // Create two temp rendertextures to hold bright pass and blur pass result
            RenderTexture brightPass = RenderTexture.GetTemporary(sourceTexture.width, sourceTexture.height);
            RenderTexture blurPass = RenderTexture.GetTemporary(sourceTexture.width, sourceTexture.height);

            // Blit using bloom shader pass 0 for bright pass ( Graphics.Blit(SOURCE, DESTINATION, MATERIAL, PASS INDEX);)
            Graphics.Blit(sourceTexture, brightPass, ScreenMat, 0);

            // Set BloomFactor to _Steps in the shader
            ScreenMat.SetFloat("_Steps", BloomFactor);

            // Blit using bloom shader pass 1 for blur pass ( Graphics.Blit(SOURCE, DESTINATION, MATERIAL, PASS INDEX);)
            Graphics.Blit(brightPass, blurPass, ScreenMat, 1);

            // Set sourceTexture to _BaseTex in the shader
            ScreenMat.SetTexture("_BaseTex", sourceTexture);

            // Blit using bloom shader pass 2 for combine pass ( Graphics.Blit(SOURCE, DESTINATION, MATERIAL, PASS INDEX);)
            Graphics.Blit(blurPass, destTexture, ScreenMat, 2);

            // Release both temp rendertextures
            RenderTexture.ReleaseTemporary(brightPass);
            RenderTexture.ReleaseTemporary(blurPass);

        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    void OnDisable()
    {
        if (screenMat)
        {
            DestroyImmediate(screenMat);
        }
    }
}
