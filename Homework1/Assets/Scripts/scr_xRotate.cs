/* WORKS CITED
 * https://unity3d.com/learn/tutorials/topics/scripting/spinning-cube
 * 
  */

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_xRotate : MonoBehaviour
{

    public float speed = 10f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.Rotate(Vector3.left , speed * Time.deltaTime);
    }
}
