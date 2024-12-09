# Lab3

## Which tasks you have completed

### Rotation Matrix
```
Matrix4::makeRotY(Vector3 t)
```
### Model Transformation (Model Matrix)
```
GameObject::localToWorld()
```
### Camera Transformation (View Matrix)
```
Camera::setPositionOrientation(Vector3 pos, Vector3 lookat)
```
### Perspective Rendering
```
Camera::setSize(int w, int h, float n, float f)
```
### Depth Buffer
```
util::getDepth(float x, float y, Vector3[] vertex )
```
### Camera Control
```
HW3::cameraControl()
```
### Backculling
```
GameObject::debugDraw()
```


## Some screenshots of your work
#### Change Position
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/position.gif)
### Change Rotation
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/rotation.gif)
### Change Scale
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/scale.gif)
### Depth Buffer
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/getDepth.gif)
(靠我們越近，顏色越深；離我們越遠，顏色越淡)
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/getDepth-1.png)
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/getDepth-2.png)
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/getDepth-3.png)
### Camera Control (只動鍵盤，沒有動滑鼠)
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/cameraControl_xy.gif)
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/cameraControl_z.gif)
### Backculling
![gif](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/screenshots/backculling.gif)


## How you completed these tasks

### Rotation Matrix
```
Matrix4::makeRotY(Vector3 t)
```
(這邊只寫了```makeRotY```跟```makeRotX```其他的Lab2有寫，且大同小異，就是公式不一樣而已)
我們設有一個基礎的矩陣為：
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/identity.svg)
，由左至右，由上至下，分別將他從```m[0]```至```m[15]```依序編號。
<br>
<br>
繞y矩陣的公式為：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_y.svg)
<br>
根據基礎矩陣及公式，修改```m[0]```、```m[2]```、```m[8]```、```m[10]```
<br>
繞x矩陣的公式為：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_x.svg)，修改```m[5]```、```m[6]```、```m[9]```、```m[10]```
<br>
* makeRotX(float a) → Pitch (rotation about the X-axis).
* makeRotY(float a) → Yaw (rotation about the Y-axis).
* makeRotZ(float a) → Roll (rotation about the Z-axis).

### Model Transformation (Model Matrix)

```
//用來計算物體的位置平移矩陣
Matrix4 translationMatrix = Matrix4.Trans(transform.position); 
```
```
//用來計算物體的旋轉矩陣，旋轉是分別繞 X 軸、Y 軸、Z 軸進行的
Matrix4 rotationMatrix = Matrix4.RotX(transform.rotation.x) 
                        .mult(Matrix4.RotY(transform.rotation.y))
                        .mult(Matrix4.RotZ(transform.rotation.z));
```
```
//用來計算物體的縮放矩陣
Matrix4 scaleMatrix = Matrix4.Scale(transform.scale);
```
```
//依次將平移、旋轉和縮放矩陣相乘，得到最終的模型矩陣
return translationMatrix.mult(rotationMatrix).mult(scaleMatrix);
```
### Camera Transformation (View Matrix)
```
// 定義上向量
Vector3 topVector = new Vector3(0, 1, 0);  
```
```
Vector3 forward = lookat.sub(pos);   // 計算朝向向量
forward.normalize();  // 正規化朝向向量
```
```
Vector3 right = Vector3.cross(topVector, forward);   // 計算右向量
right.normalize();  // 正規化右向量
```
```
Vector3 up = Vector3.cross(right, forward);    // 計算上向量
up.normalize();    // 正規化上向量
```
```
// 初始化矩陣
worldView = Matrix4.Identity();
```
```
// 填充矩陣
// (右向量)
worldView.m[0] = right.x;
worldView.m[1] = right.y;
worldView.m[2] = right.z;
worldView.m[3] = -Vector3.dot(right, pos);

// (上向量)
worldView.m[4] = up.x;
worldView.m[5] = up.y;
worldView.m[6] = up.z;
worldView.m[7] = -Vector3.dot(up, pos);

// (朝向向量)
worldView.m[8] = -forward.x;
worldView.m[9] = -forward.y;
worldView.m[10] = -forward.z;
worldView.m[11] = -Vector3.dot(forward, pos);

// 設置平移
worldView.m[12] = 0;
worldView.m[13] = 0;
worldView.m[14] = 0;
worldView.m[15] = 1;
```

### Perspective Rendering
```
// 設定相機屬性
wid = w;
hei = h;
near = n;
far = f;
```
```
// 初始化投影矩陣
projection = Matrix4.Identity();
```
```
// 計算寬高比（Aspect Ratio）
float aspectRatio = (float)w / (float)h;
```
```
// 設置投影矩陣為透視投影
projection.m[0] = 1.0f / (aspectRatio * (float)Math.tan(Math.toRadians(GH_FOV / 2.0f)));
projection.m[5] = 1.0f / (float)Math.tan(Math.toRadians(GH_FOV / 2.0f));
projection.m[10] = (far + near) / (near - far);
projection.m[11] = (2.0f * far * near) / (near - far);
projection.m[14] = -1.0f;
projection.m[15] = 0.0f;
```
透視投影原理：
1. 設置水平和垂直縮放因子

```projection.m[0]``` 和 ```projection.m[5]``` 分別對應水平和垂直方向的縮放因子，計算方式為：
<br>
<br>
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/Horizontal_zoom.svg)
<br>
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/vertical_zoom.svg)

2. 設置深度方向的投影參數

```projection.m[10]``` 和 ```projection.m[11]``` 用於將深度（Z 軸）壓縮到 ```[−1,1]``` 的範圍內：
<br>
<br>
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/m[10].svg)
<br>
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/m[11].svg)

3. 設置透視投影的偏移

* ```​projection.m[14] = -1.0f```：表示投影矩陣的透視性，將 3D 點壓縮到 2D。
* ```projection.m[15] = 0.0f```：固定在透視投影的標準形式中，表示投影到齊次坐標。


### Depth Buffer
```
// 提取三角形的三個頂點
Vector3 A = vertex[0];
Vector3 B = vertex[1];
Vector3 C = vertex[2];
```
```
// 計算三角形的面積
float triangleArea = Math.abs((B.x - A.x) * (C.y - A.y) - (C.x - A.x) * (B.y - A.y));
```
叉積公式：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/triangle.svg)
<br>
我們省略了```1/2```，因為我們只需要比例，並不關注實際面積大小。
```
// 防止面積為零時出現問題
if (triangleArea == 0) {
    return 0.0f; 
}
```
```
// 計算三個小三角形的面積，分別對應點 (x, y) 與三個頂點之一
float areaPBC = Math.abs((B.x - x) * (C.y - y) - (C.x - x) * (B.y - y));
float areaPCA = Math.abs((C.x - x) * (A.y - y) - (A.x - x) * (C.y - y));
float areaPAB = Math.abs((A.x - x) * (B.y - y) - (B.x - x) * (A.y - y));
```
```
// 計算重心座標
float alpha = areaPBC / triangleArea;
float beta = areaPCA / triangleArea;
float gamma = areaPAB / triangleArea;
```
```
// 使用重心座標加權計算深度 z 值
float depth = alpha * A.z + beta * B.z + gamma * C.z;
```
```
// 限制深度值範圍
return Math.max(0.0f, Math.min(1.0f, depth));
```

### Camera Control
```
// 設定移動速度
float moveSpeed = 0.1f;
```
```
// 用鍵盤控制相機位置
if (key == 'W' || key == 'w') {
    cam_position.y += moveSpeed;  // 向上移動
}
if (key == 'S' || key == 's') {
    cam_position.y -= moveSpeed;  // 向下移動
}
if (key == 'A' || key == 'a') {
    cam_position.x -= moveSpeed;  // 向左移動
}
if (key == 'D' || key == 'd') {
    cam_position.x += moveSpeed;  // 向右移動
}
if (key == 'Q' || key == 'q') {
    cam_position.z += moveSpeed;  // 向前移動
}
if (key == 'E' || key == 'e') {
    cam_position.z -= moveSpeed;  // 向後移動
}
```
```
// 更新相機位置
main_camera.setPositionOrientation(cam_position, lookat);
```
### Backculling
```
// 初始化與計算必要的矩陣
Matrix4 MVP = main_camera.Matrix().mult(localToWorld());
Matrix4 modelMatrix = localToWorld();
Vector3 cam_position = main_camera.Matrix().translation();
```
```
// 遍歷模型的三角形
for (int i = 0; i < mesh.triangles.size(); i++) {
    Triangle triangle = mesh.triangles.get(i);
```
```
// 將三角形的每個頂點透過 modelMatrix 轉換到世界空間
Vector3 worldA = modelMatrix.mult(triangle.verts[0].getVector4(1.0)).homogenized();
Vector3 worldB = modelMatrix.mult(triangle.verts[1].getVector4(1.0)).homogenized();
Vector3 worldC = modelMatrix.mult(triangle.verts[2].getVector4(1.0)).homogenized();
```
```
// 計算法向量與相機方向
Vector3 edge1 = worldB.sub(worldA);
Vector3 edge2 = worldC.sub(worldA);
Vector3 normal = Vector3.cross(edge1, edge2).unit_vector();

Vector3 camDirection = cam_position.sub(worldA).unit_vector();
```
```edge1```和```edg2```是三角形的兩個邊向量。
<br>
```normal```是三角形的法向量，透過兩個邊向量的叉積計算，並歸一化為單位向量。
<br>
```camDirection```是從三角形頂點指向相機位置的向量，也經過單位化。

```
// 背面剔除
if (Vector3.dot(normal, camDirection) <= 0) {
    continue;
}
```
透過法向量與視線方向的點積判斷三角形是否背向相機：
<br>
如果點積小於等於零，表示三角形的面朝遠離相機的方向。這種情況下會進行「背面剔除」，不繪製該三角形。

```
// 投影到屏幕空間
Vector3[] img_pos = new Vector3[3];
for (int j = 0; j < 3; j++) {
    img_pos[j] = MVP.mult(triangle.verts[j].getVector4(1.0)).homogenized();
}
```
使用```MVP```矩陣將三角形的三個頂點轉換到屏幕空間。並用```.homogenized()```還原齊次座標。
```
// 屏幕空間到像素空間的映射
for (int j = 0; j < img_pos.length; j++) {
    img_pos[j] = new Vector3(
        map(img_pos[j].x, -1, 1, renderer_size.x, renderer_size.z),
        map(img_pos[j].y, -1, 1, renderer_size.w, renderer_size.y),
        img_pos[j].z()
    );
}
```
將屏幕空間的座標（範圍為 -1 到 1）映射到實際的像素座標。
<br>
```map```函數將數值從一個範圍線性映射到另一個範圍：
X 軸從```[-1, 1]```映射到像素範圍```[renderer_size.x, renderer_size.z]```。
Y 軸從```[-1, 1]```映射到像素範圍```[renderer_size.w, renderer_size.y]```。

```
// 繪製三角形邊線
CGLine(img_pos[0].x, img_pos[0].y, img_pos[1].x, img_pos[1].y);
CGLine(img_pos[1].x, img_pos[1].y, img_pos[2].x, img_pos[2].y);
CGLine(img_pos[2].x, img_pos[2].y, img_pos[0].x, img_pos[0].y);
```
