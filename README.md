# Lab4

## Which tasks you have completed
### Barycentric Coordinates
```
util::barycentric(Vector3 P, Vector4[] verts)
```
### Phong Shading
```
Material::PhongMaterial
ColorShader::PhongVertexShader
ColorShader::PhongFragmentShader
```

## Some screenshots of your work
### 可改變光源的位置
![image](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab4/screenshots/light_position.gif)
### 可改變物體的顏色(Phong Shading)
![image](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab4/screenshots/phong_color.gif)
### FlatMaterial
我感覺沒成功QAQ，沒有什麼光線的變化QAQ
![image](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab4/screenshots/flat.gif)

## How you completed these tasks
### Barycentric Coordinates
```
util::barycentric(Vector3 P, Vector4[] verts)
```
```
// 將頂點 𝐴,𝐵,𝐶 的 Vector4（包含 𝑤 分量）轉換為  Vector3，得到去齊次化的坐標。

Vector3 A = verts[0].homogenized();
Vector3 B = verts[1].homogenized();
Vector3 C = verts[2].homogenized();

// 同時保留 𝐴𝑊,𝐵𝑊,𝐶𝑊 的齊次坐標，用於透視校正。

Vector4 AW = verts[0];
Vector4 BW = verts[1];
Vector4 CW = verts[2];
```
```
// 計算三角形的總面積
float areaABC = Math.abs((B.x - A.x) * (C.y - A.y) - (C.x - A.x) * (B.y - A.y));

if (areaABC == 0) {
    return new float[]{0.0f, 0.0f, 0.0f}; // 避免除以零的情況
    }
```
面積公式：![image](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab3/mathImg/triangle.svg)

```
 // 計算三個子三角形的面積
float areaPBC = Math.abs((B.x - P.x) * (C.y - P.y) - (C.x - P.x) * (B.y - P.y));
float areaPCA = Math.abs((C.x - P.x) * (A.y - P.y) - (A.x - P.x) * (C.y - P.y));
float areaPAB = Math.abs((A.x - P.x) * (B.y - P.y) - (B.x - P.x) * (A.y - P.y));
```
```
// 計算未經校正的重心坐標
float alpha = areaPBC / areaABC;
float beta = areaPCA / areaABC;
float gamma = areaPAB / areaABC;
```
```
// 透視校正
alpha /= AW.w;
beta /= BW.w;
gamma /= CW.w;

// 計算校正後的權重總和
float weightSum = alpha + beta + gamma;

// 將校正後的重心坐標進行標準化
alpha /= weightSum;
beta /= weightSum;
gamma /= weightSum;
```
```
// 將結果存入 result
float[] result = {alpha, beta, gamma};

//返回重心座標
return result;
```


### Phong Shading
```
ColorShader::PhongFragmentShader
```
```
// 計算光線方向
Vector3 lightDir = light.transform.position.sub(w_position);
lightDir.normalize();
```
```
//  計算觀察方向
Vector3 viewDir = (cam.transform.position.sub(w_position));
viewDir.normalize();
```
```
// 計算反射方向
Vector3 reflectDir = lightDir.reflect(w_normal);
```
```
// Reflect method
public Vector3 reflect(Vector3 normal) {
    return this.sub(normal.mult(2 * dot(this, normal)));
}
```
```
// 漫反射分量計算
float diffuse = Math.max(Vector3.dot(w_normal, lightDir), 0.0); 
```
dot結果越大，說明光線與法線夾角越小，漫反射效果越強
<br>
使用 ```Math.max()``` 確保點積結果為非負數（避免背面被照亮）
```
// 高光反射分量計算
float specular = (float) Math.pow(Math.max(Vector3.dot(viewDir, reflectDir), 0.0), kdksm.z);
```
dot結果越接近 1，代表觀察方向與反射方向越接近，高光越強
```
// 計算總顏色
float kdksm_x_diffuse = kdksm.x * diffuse;
float kdksm_y_specular = kdksm.y * specular;

Vector3 diffuseComponent = albedo.mult(kdksm.x * diffuse);
Vector3 specularComponent = albedo.mult(kdksm.y * specular * light.intensity);
Vector3 colors = diffuseComponent.add(specularComponent);
```
```
// 返回片段顏色
return new Vector4(colors.x, colors.y, colors.z, 1.0);
```


### Flat Shading

```
ColorShader::FlatVertexShader
```
```
// 頂點資料與變換矩陣初始化
Vector3[] aVertexPosition = (Vector3[]) attribute[0]; // 三角形的三個頂點位置
Matrix4 MVP = (Matrix4) uniform[0]; // 模型-視圖-投影矩陣，用於將頂點轉換到裁剪空間。
Matrix4 modelMatrix = (Matrix4) uniform[1]; // 模型矩陣，用於將頂點轉換到世界空間。
Vector4[] gl_Position = new Vector4[3]; // 裁剪空間中的頂點位置，OpenGL 的基礎輸出，用於後續的圖形渲染管線。
Vector4[] w_position = new Vector4[3]; // 世界空間中的頂點位置，用於光照計算。
```
```
// 計算三角形的面法線
Vector3 edge1 = aVertexPosition[1].sub(aVertexPosition[0]);
Vector3 edge2 = aVertexPosition[2].sub(aVertexPosition[0]);
Vector3 faceNormal = Vector3.cross(edge1, edge2);
faceNormal.normalize(); // 計算並歸一化法線
```
```
// 將頂點轉換到世界空間和裁剪空間
for (int i = 0; i < gl_Position.length; i++) {
    w_position[i] = modelMatrix.mult(aVertexPosition[i].getVector4(1.0));
    gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
}
```
```
// 將法線作為輸出傳遞
Vector4 faceNormalOutput = faceNormal.getVector4(0.0); // 將 Vector3 轉換為 Vector4
```
```
// 數據輸出到片段著色器
Vector4[][] result = { gl_Position, w_position, { faceNormalOutput } };

return result;
```

```
ColorShader::FlatFragmentShader
```
```
// 接收輸入數據
Vector3 faceNormal = ((Vector4) varying[2]).xyz(); // 面法線
Vector3 w_position = ((Vector4) varying[1]).xyz(); // 世界空間位置
Vector3 albedo = new Vector3(1.0, 0.5, 0.3); // 材質顏色
Camera cam = main_camera; // 相機
Light light = basic_light; // 光源
```
```
// 計算光源方向
Vector3 lightDir = light.transform.position.sub(w_position); // 光源方向
lightDir.normalize();
```
```
// 計算漫反射分量
float diffuse = Math.max(Vector3.dot(faceNormal, lightDir), 0.0);
```
```
// 計算片段顏色
Vector3 colors = albedo.mult(diffuse * light.intensity);
```
```
// 返回片段顏色
return new Vector4(colors.x, colors.y, colors.z, 1.0);
```
