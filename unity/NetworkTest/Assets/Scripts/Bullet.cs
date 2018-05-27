using UnityEngine;
using System.Collections;

public class Bullet : MonoBehaviour {

    private void OnCollisionEnter(Collision other) { 
        Destroy(gameObject);

        var hit = other.gameObject;
        var health = hit.GetComponent<Health>();
        if (health != null)
            health.TakeDamage(10);
    }
    
}