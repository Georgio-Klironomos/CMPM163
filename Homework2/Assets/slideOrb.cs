using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class slideOrb : MonoBehaviour
{
    public float orbX;
    // Start is called before the first frame update
    void Start()
    {
        orbX = this.transform.position.x;
    }

    public void slideIt(float newVal)
    {
        this.transform.position = new Vector3(orbX - newVal, transform.position.y, transform.position.z);
    }
}