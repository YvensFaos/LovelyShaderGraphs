using UnityEngine;
using UnityEngine.EventSystems;

public class AnimateOnHover : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    public Material animateMaterial;
    public void OnPointerEnter(PointerEventData eventData)
    {
        animateMaterial.SetInt("_Animate", 1);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        animateMaterial.SetInt("_Animate", 0);
    }
}
