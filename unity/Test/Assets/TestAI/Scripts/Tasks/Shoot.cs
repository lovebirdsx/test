using UnityEngine;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;

[TaskCategory("TestAI")]
[TaskDescription("Shoot the target")]
public class Shoot : Action
{
	public SharedTransform target;

	Player player;

	public override void OnStart()
	{
		player = gameObject.GetComponent<Player>();
		player.Shoot(target.Value.position);
	}

	public override TaskStatus OnUpdate()
	{
		return TaskStatus.Success;
	}
}