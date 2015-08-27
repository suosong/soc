using UnityEngine;
using System.Collections;

public class MoveScript : MonoBehaviour {

    private CharacterController controller; 

	// Use this for initialization
	void Start () {
        controller = GetComponent<CharacterController>();  
	}
	
	// Update is called once per frame
	void Update () {
	    Vector3 move = Physics.gravity * Time.deltaTime;
        controller.Move(move);
	}
}
