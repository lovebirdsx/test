using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

[TaskCategory("TestAI")]
[TaskDescription("Rand move for some distance")]
public class RandMove : Action
{
	public float minDistance = 0.2f;
	public float maxDistance = 0.5f;

	Player player;

	public override void OnStart()
	{
		player = gameObject.GetComponent<Player>();

		Vector3 pos = Random.Range(minDistance, maxDistance) * Random.insideUnitSphere + gameObject.transform.position;
		player.Move(pos);
	}

	public override TaskStatus OnUpdate()
	{
		if (player.IsMoveFinished)
			return TaskStatus.Success;
		else
			return TaskStatus.Running;
	}
}