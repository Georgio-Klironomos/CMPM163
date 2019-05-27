using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PitchLevel : MonoBehaviour
{
    public float orbX;
    public AudioSource music;
    // Start is called before the first frame update
    void Start()
    {
        music = GetComponent<AudioSource>();
        orbX = music.pitch;
    }

    // Update is called once per frame
    public void slideIt(float newVal)
    {
        music.pitch = newVal;
    }
}
