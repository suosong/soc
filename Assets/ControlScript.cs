using UnityEngine;
using System.Collections;

public class ControlScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	    //float s = Input.GetAxis("Horizontal");
        if (Input.GetKey(KeyCode.W))
        {
            Debug.Log("您按下了W键");
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            Debug.Log("您按下了S键");
        }

        if (Input.GetKeyDown(KeyCode.A))
        {
            Debug.Log("您按下了A键");
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            Debug.Log("您按下了D键");
        }
	}
}
