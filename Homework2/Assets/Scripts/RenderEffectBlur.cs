using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderEffectBlur : MonoBehaviour
{

    public Shader curShader;
    public GameObject carGameObject;
    private Material screenMat;

    private float curSpeed;
    private float topSpeed;
    private UnityStandardAssets.Vehicles.Car.CarController car;

    Material ScreenMat
    {
        get
        {
            if (screenMat == null)
            {
                screenMat = new Material(curShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return screenMat;
        }
    }


    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
        car = carGameObject.GetComponent<UnityStandardAssets.Vehicles.Car.CarController>();
        topSpeed = car.MaxSpeed;
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (curShader != null)
        {
            //Get current car speed
            curSpeed = car.CurrentSpeed;
            //Calculate blur factor with current speed and top speed
            float blurFactor = Mathf.Clamp((curSpeed / topSpeed) * 5, 0, 40);
            //Set "_Steps" in shader. Interpolate linearly from 0 to 20 based on blur factor
            ScreenMat.SetFloat("_Steps", blurFactor * Mathf.Lerp(0, 20, blurFactor));

            Graphics.Blit(sourceTexture, destTexture, ScreenMat);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnDisable()
    {
        if (screenMat)
        {
            DestroyImmediate(screenMat);
        }
    }
}
