using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class TankHealth : NetworkBehaviour
{
    public float m_StartingHealth = 100f;          
    public Slider m_Slider;                        
    public Image m_FillImage;                      
    public Color m_FullHealthColor = Color.green;  
    public Color m_ZeroHealthColor = Color.red;    
    public GameObject m_ExplosionPrefab;    

    private AudioSource m_ExplosionAudio;          
    private ParticleSystem m_ExplosionParticles;   
    [SyncVar(hook = "OnChangeHealth")]
    private float m_CurrentHealth;  
    private bool m_Dead;            


    private void Awake()
    {
        m_ExplosionParticles = Instantiate(m_ExplosionPrefab).GetComponent<ParticleSystem>();
        m_ExplosionAudio = m_ExplosionParticles.GetComponent<AudioSource>();

        m_ExplosionParticles.gameObject.SetActive(false);
    }

    private void OnChangeHealth(float health)
    {
        SetHealthUI(health);
    }

    private void OnEnable()
    {
        m_CurrentHealth = m_StartingHealth;
        m_Dead = false;

        SetHealthUI(m_StartingHealth);
    }    

    public void TakeDamage(float amount)
    {
        if (!isServer)
            return;

        // Adjust the tank's current health, update the UI based on the new health and check whether or not the tank is dead.
        m_CurrentHealth -= amount;
        if (m_CurrentHealth <= 0f && !m_Dead)
        {
            gameObject.SetActive(false);
            RpcOnDeath();
        }
    }

    private void SetHealthUI(float health)
    {
        // Adjust the value and colour of the slider.
        m_Slider.value = health;
        m_FillImage.color = Color.Lerp(m_ZeroHealthColor, m_FullHealthColor, health / m_StartingHealth);
    }

    [ClientRpc]
    private void RpcOnDeath()
    {
        // Play the effects for the death of the tank and deactivate it.
        m_Dead = true;
        m_ExplosionParticles.transform.position = transform.position;
        m_ExplosionParticles.gameObject.SetActive(true);

        m_ExplosionParticles.Play();
        m_ExplosionAudio.Play();
        gameObject.SetActive(false);
    }
}