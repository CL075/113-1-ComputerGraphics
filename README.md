# Lab3

## Which tasks you have completed

#### Rotation Matrix
```
Matrix4::makeRotY(Vector3 t)
```
#### Model Transformation (Model Matrix)
```
GameObject::localToWorld()
```
#### Camera Transformation (View Matrix)
```
Camera::setPositionOrientation(Vector3 pos, Vector3 lookat)
```
#### Perspective Rendering
```
Camera::setSize(int w, int h, float n, float f)
```
#### Depth Buffer
```
util::getDepth(float x, float y, Vector3[] vertex )
```
#### Camera Control
```
HW3::cameraControl()
```
#### Backculling
```
GameObject::debugDraw()
```


## Some screenshots of your work
![image]()
![image]()
![image]()

## How you completed these tasks

#### Rotation Matrix
```
Matrix4::makeRotY(Vector3 t)
```
我們設有一個基礎的矩陣為：
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/identity.svg)
，由左至右，由上至下，分別將他從```m[0]```至```m[15]```依序編號。
<br>
<br>
繞y矩陣的公式為：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_y.svg)
<br>
根據基礎矩陣及公式，修改```m[0]```、```m[2]```、```m[8]```、```m[10]```

#### Model Transformation (Model Matrix)

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
#### Camera Transformation (View Matrix)
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
// 初始化視圖矩陣
worldView = Matrix4.Identity();
```
```
// 設置旋轉部分
worldView.m[0] = right.x;
worldView.m[1] = right.y;
worldView.m[2] = right.z;

worldView.m[4] = up.x;
worldView.m[5] = up.y;
worldView.m[6] = up.z;

worldView.m[8] = -forward.x;
worldView.m[9] = -forward.y;
worldView.m[10] = -forward.z;
```
上面的程式碼是依照這個矩陣來設定的：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/worldView.svg)
<br>
第一列是右向量。
<br>
第二列是上向量。
<br>
第三列是負的前向量（因為相機的前向量和世界的前向量相反）。
```
// 設置平移部分
worldView.m[12] = -pos.x;
worldView.m[13] = -pos.y;
worldView.m[14] = -pos.z;
```
平移部分矩陣結構：
* 視圖矩陣需要將世界中的所有點相對於相機的位置進行平移。
* 平移向量取負值，因為視圖矩陣本質上是相機位置的反變換。

#### Perspective Rendering
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

<br>
投影矩陣的最終形式： ![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/final.svg)


#### Depth Buffer
```
util::getDepth(float x, float y, Vector3[] vertex )
```
#### Camera Control
```
HW3::cameraControl()
```
#### Backculling
```
GameObject::debugDraw()
```
