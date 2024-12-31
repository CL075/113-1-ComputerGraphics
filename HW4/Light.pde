class Light extends GameObject {
    Vector3 light_color;
    float intensity;

    Light() {
        transform = new Transform(); // 確保 transform 被正確初始化
        light_color = new Vector3(0.8, 0.8, 0.8);
        intensity = 1.0f;
        transform.position = new Vector3(10.0, 10.0, -10.0);
        name = "Light";
    }
}
