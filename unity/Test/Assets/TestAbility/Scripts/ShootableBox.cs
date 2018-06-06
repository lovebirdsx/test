using UnityEngine;

namespace TestAblity
{
    public class ShootableBox : MonoBehaviour
    {
        public float health = 100;
        public void Damage(int damg)
        {
            health -= damg;
        }
    }
}