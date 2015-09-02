using UnityEngine;
using System.Collections;

public class ControlScript : MonoBehaviour {

    private float hold_time = 0; // 被持球时长
    private GameObject holder = null;    // 持球人
    public GameObject player1 = null;
    public GameObject player2 = null;

	// Use this for initialization
	void Start () {
	    
	}
	
	// Update is called once per frame
	void Update () {
        // 无持球人或持球时间超过0.3秒情况下，距离球小于0.2米且是与球距离最近的人获得球

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
