using BehaviorDesigner.Runtime;
using BehaviorDesigner.Runtime.Tasks;
using UnityEngine;
using Tooltip = BehaviorDesigner.Runtime.Tasks.TooltipAttribute;

[TaskCategory("TestAI")]
[TaskDescription("Test If can shoot any enemy")]
public class CanShootEnemy : Conditional
{
    public SharedGameObject gameManagerObj;
    public SharedTransform target;

    Player player;
    GameManager gameManager;
    Transform[] enemies;

    public override void OnStart()
    {
        player = gameObject.GetComponent<Player>();
        gameManager = gameManagerObj.Value.GetComponent<GameManager>();
        
        if (gameManager.players.Length > 1)
        {
            enemies = new Transform[gameManager.players.Length - 1];
            int i = 0;
            foreach (Player player in gameManager.players)
            {
                if (player != this.player)
                {
                    enemies[i++] = player.GetComponent<Transform>();
                }
            }
        }
    }

    public override TaskStatus OnUpdate()
    {
        if (!player.CanShoot)
            return TaskStatus.Failure;

        Vector3 selfPos = player.GetComponent<Transform>().position;
        foreach (Transform enemy in enemies)
        {
            if (Vector3.Distance(enemy.position, selfPos) < player.bulletRange)
            {
                target.Value = enemy;
                return TaskStatus.Success;
            }
        }
        
        return TaskStatus.Failure;
    }
}