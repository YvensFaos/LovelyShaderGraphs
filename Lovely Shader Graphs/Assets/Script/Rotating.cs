using UnityEngine;

public class Rotating : MonoBehaviour
{
    [SerializeField]
    private Vector3 axis;
    [SerializeField]
    private float velocity;

    private void Update()
    {
        transform.Rotate(axis, velocity * Time.deltaTime);     
    }
}
