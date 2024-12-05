import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public Vector4 renderer_size;
static public float GH_FOV = 45.0f;
static public float GH_NEAR_MIN = 1e-3f;
static public float GH_NEAR_MAX = 1e-1f;
static public float GH_FAR = 1000.0f;

public boolean debug = true;

public float[] GH_DEPTH;
public PImage renderBuffer;

Engine engine;
Camera main_camera;
Vector3 cam_position;
Vector3 lookat;

void setup() {
    size(1000, 600);
    renderer_size = new Vector4(20, 50, 520, 550);
    cam_position = new Vector3(0, 0, -10);
    lookat = new Vector3(0, 0, 0);
    setDepthBuffer();
    main_camera = new Camera();
    engine = new Engine();

}

void setDepthBuffer(){
    renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
    GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
    for(int i = 0 ; i < GH_DEPTH.length;i++){
        GH_DEPTH[i] = 1.0;
        renderBuffer.pixels[i] = color(1.0*250);
    }
}

void draw() {
    background(255);

    engine.run();
    cameraControl();
}

String selectFile() {
    JFileChooser fileChooser = new JFileChooser();
    fileChooser.setCurrentDirectory(new File("."));
    fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
    fileChooser.setFileFilter(filter);

    int result = fileChooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
        String filePath = fileChooser.getSelectedFile().getAbsolutePath();
        return filePath;
    }
    return "";
}

void cameraControl(){
    // You can write your own camera control function here.
    // Use setPositionOrientation(Vector3 position,Vector3 lookat) to modify the ViewMatrix.
    // Hint : Use keyboard event and mouse click event to change the position of the camera.    

    // 定義移動速度
    float moveSpeed = 0.1f;
    float rotateSpeed = 0.01f;  // 設置旋轉速度

    // 用鍵盤事件控制攝像機位置
    if (key == 'W' || key == 'w') {
        cam_position.z += moveSpeed;  // 向前移動
    }
    if (key == 'S' || key == 's') {
        cam_position.z -= moveSpeed;  // 向後移動
    }
    if (key == 'A' || key == 'a') {
        cam_position.x -= moveSpeed;  // 向左移動
    }
    if (key == 'D' || key == 'd') {
        cam_position.x += moveSpeed;  // 向右移動
    }

    // 鼠標控制攝像機視角
    if (mousePressed) {
        // 基於鼠標的相對移動來旋轉攝像機
        float deltaX = mouseX - pmouseX;  // 計算鼠標的移動量
        float deltaY = mouseY - pmouseY;

        // 旋轉的角度改變
        float angleX = deltaY * rotateSpeed;  // 上下旋轉
        float angleY = deltaX * rotateSpeed;  // 左右旋轉

        // 更新視線方向
        Vector3 lookat = new Vector3(0, 0, 0);  // 硬編碼目標點 (你可以根據需要改變)
        main_camera.setPositionOrientation(cam_position, new Vector3(0, 0, 1));  // 設定視角
        main_camera.rotate(angleX, new Vector3(1, 0, 0));  // 根據鼠標移動上下旋轉
        main_camera.rotate(angleY, new Vector3(0, 1, 0));  // 根據鼠標移動左右旋轉
    }

    // 更新攝像機位置
    main_camera.setPositionOrientation(cam_position, new Vector3(0, 0, 1));
        
    //main_camera.setPositionOrientation(cam_position, new Vector3(0,0,1));

}
