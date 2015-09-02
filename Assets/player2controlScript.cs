using UnityEngine;
using System.Collections;

public class player2controlScript : MonoBehaviour {

    private CharacterController controller;
    private Animator anim;

	// Use this for initialization
	void Start () {
        controller = GetComponent<CharacterController>();
        anim = GetComponent<Animator>();  
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKey(KeyCode.W))
        {
            anim.Play("run");
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            anim.Play("attack1");
        }

        if (Input.GetKeyDown(KeyCode.A))
        {
            anim.Play("run");
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            anim.Play("attack1");
        }

        Vector3 move = Physics.gravity * Time.deltaTime;
        controller.Move(move);
	}
}
