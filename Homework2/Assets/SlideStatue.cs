using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlideStatue : MonoBehaviour
{
    public float orbX;
    // Start is called before the first frame update
    void Start()
    {
        orbX = this.transform.position.y;
    }

    public void slideIt(float newVal)
    {
        this.transform.position = new Vector3(transform.position.x, orbX - newVal, transform.position.z);
    }
}