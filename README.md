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
### Flat Shading
```
Material::FlatMaterial
ColorShader::FlatVertexShader
ColorShader::FlatFragmentShader
```
### Gouraud Shading
```
Material::GouraudMaterial
ColorShader::GouraudVertexShader
ColorShader::GouraudFragmentShader
```

## Some screenshots of your work
### Phong Shading
可改變物體顏色、光源的位置、光源強度
![image](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab4/screenshots/phong_color.gif)
![image](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab4/screenshots/phong_light.gif)

### Flat Shading
我感覺沒成功QAQ，沒有什麼光線的變化QAQ
![image](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab4/screenshots/flat.gif)

### Gouraud Shading
會當機QAQ

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
reflectDir.normalize();
```
```
// Reflect method
public Vector3 reflect(Vector3 normal) {
    return this.sub(normal.mult(2 * dot(this, normal)));
}
```
```
// 計算 Phong 着色模型 中的環境光 (Ambient Light) 分量。
Vector3 ambientComponent = albedo.mult(0.5f);
```
當乘的數值越小，它的環境光就會降低，所以整個物件會起來會非常黑。
但當乘的越大，他反而會太亮導致他沒有了物件的細節。
所以我這邊放了偏中間的數值。
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
Material::FlatMaterial
```
```
// 提取三角形的頂點和法向量
Vector3[] position = triangle.verts;
Vector3 normal = triangle.normal[0];
```
```
// 法向量轉換為 Vector4
Vector4[] normals = { normal.getVector4(0.0) };

// 調用頂點著色器邏輯
Vector4[][] r = shader.vertex.main(new Object[] { position }, new Object[] { MVP, triangle });

// 合併法向量
return new Vector4[][] { r[0], normals };
```

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

### Gouraud Shading

```
Material::GouraudMaterial
```
```
// 頂點處理與著色器調用
Vector4[][] r = shader.vertex.main(new Object[] { triangle.verts }, new Object[] { MVP, triangle.normal });
```
```
ColorShader::GouraudVertexShader
```
```
Vector3[] aVertexPosition = (Vector3[]) attribute[0]; // 輸入的頂點位置，是一個 Vector3[]，表示三角形的三個頂點
Matrix4 MVP = (Matrix4) uniform[0]; // 模型-視圖-投影矩陣，用於將頂點位置從局部空間轉換到螢幕空間
Vector3[] normal = (Vector3[]) uniform[1]; // 三角形的法向量，用於光照強度計算
Vector3 lightDir = basic_light.transform.position; // 光源的方向，從光源位置轉換後正規化，確保後續的點積運算不受向量長度影響
lightDir.normalize();
```
```
// 頂點著色與 Gouraud 着色實現
for (int i = 0; i < gl_Position.length; i++) {

    // 將頂點位置 (aVertexPosition[i]) 擴展為 4 維向量，然後通過 MVP 矩陣進行變換，得到屏幕空間的座標
    gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));

    // 使用 法向量 (normal[i]) 與光源方向 (lightDir) 的點積計算光照強度
    float intensity = Math.max(Vector3.dot(normal[i], lightDir), 0.0);

    // 使用強度值設置頂點的顏色 (vertexColors[i])
    vertexColors[i] = new Vector3(intensity, intensity, intensity);
}
```
```
// 將 Vector3 的顏色數據轉換為 Vector4 格式，並附加 1.0 作為第四個維度，確保與其他數據類型一致。
Vector4[] vertexColors4 = new Vector4[3];
for (int i = 0; i < vertexColors.length; i++) {
    vertexColors4[i] = vertexColors[i].getVector4(1.0); 
}

// 返回結果
Vector4[][] result = { gl_Position, vertexColors4 };
return result;
```

```
ColorShader::GouraudFragmentShader
```
```
// 插值後的顏色數據，由頂點著色器基於 Gouraud 着色模型計算的光照結果
Vector3 colors = (Vector3) varying[1];

// 將 RGB 值從 Vector3 轉換為 Vector4，並附加 Alpha 通道值為 1.0（完全不透明）
return new Vector4(colors.x, colors.y, colors.z, 1.0);
```

### 其餘有修改的地方

```
HW4.pde

cam_position = new Vector3(0, 0, -10);
```
我要添加```cameraControl```的時候，他好像沒有初始化所以會抱錯，把它加上去就可以了。

```
Vector3.pde

// Reflect method
public Vector3 reflect(Vector3 normal) {
    return this.sub(normal.mult(2 * dot(this, normal)));
}
```
添加了一個關於反射的function。

