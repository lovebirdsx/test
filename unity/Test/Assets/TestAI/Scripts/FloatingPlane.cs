using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum MoveDirection
{
    Left,
    Right
}

[RequireComponent(typeof(Rigidbody))]
public class FloatingPlane : MonoBehaviour
{
	public Transform tran1;
	public Transform tran2;
    public float moveSpeed = 1.0f;
    public float stillTime = 2.0f;
    public MoveDirection startMoveDirection = MoveDirection.Left;

    Vector3 pos1;
    Vector3 pos2;
    Rigidbody rb;
	WaitForEndOfFrame waitForEndofFrame;
	WaitForSeconds waitStill;
	MoveDirection moveDirection;

    // Use this for initialization
    void Start()
    {
		pos1 = tran1.position;
		pos1.z = transform.position.z;
		pos2 = tran2.position;
		pos2.z = transform.position.z;
		Debug.Log("pos1 = " + pos1);
		Debug.Log("pos2 = " + pos2);
		rb = GetComponent<Rigidbody>();

		waitForEndofFrame = new WaitForEndOfFrame();
		waitStill = new WaitForSeconds(stillTime);
		moveDirection = startMoveDirection;

		StartCoroutine(_Run());
    }

	private IEnumerator _MoveToEndByForce()
	{
		rb.isKinematic = false;
		float maxS = Vector3.Distance(pos1, pos2);
		Vector3 startPos = transform.position;
		Vector3 endPos = (moveDirection == MoveDirection.Left) ? pos1 : pos2;

		if (Vector3.Distance(endPos, startPos) > 0.1f)
		{
			Vector3 force = Vector3.Normalize(endPos - startPos) * 10;
			rb.AddForce(force);

			while (Vector3.Distance(transform.position, endPos) < 0.1f)
			{
				yield return waitForEndofFrame;
			}
		}

		// 设定终点位置
		rb.velocity = Vector3.zero;
		transform.position = endPos;

		// 等待一段时间
		yield return waitStill;
	}

	private IEnumerator _MoveToEnd()
	{
		// 设定移动速度
		float maxS = Vector3.Distance(pos1, pos2);
		Vector3 startPos = transform.position;
		Vector3 endPos = (moveDirection == MoveDirection.Left) ? pos1 : pos2;
		float s = Vector3.Distance(transform.position, endPos);
		float t = s / moveSpeed;
		float startTime = Time.time;
		float endTime = startTime + t;

		// 等待移动到终点
		while (Time.time < endTime && t > 0)
		{
			transform.position = startPos + (endPos - startPos) * (Time.time - startTime) / t;
			yield return waitForEndofFrame;
		}

		// 设定终点位置
		transform.position = endPos;

		// 等待一段时间
		yield return waitStill;
	}

    private IEnumerator _Run()
    {
		while (true)
		{
        	yield return StartCoroutine(_MoveToEnd());
        	// yield return StartCoroutine(_MoveToEndByForce());

			// 改变移动的方向
			moveDirection = (moveDirection == MoveDirection.Left) ? MoveDirection.Right : MoveDirection.Left;
			Debug.Log("Change dir to " + moveDirection);
		}
    }
}
