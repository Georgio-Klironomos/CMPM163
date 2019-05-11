//WORKS CITED https://www.youtube.com/watch?v=OJkGGuudm38

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplaceXRay : MonoBehaviour
{
    public Shader XRayShader;

    private void OnEnable()
    {
        GetComponent<Camera>().SetReplacementShader(XRayShader, "XRay");
    }
}
