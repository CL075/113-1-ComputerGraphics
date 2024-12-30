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
### 
![image]()

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
Material::PhongMaterial
ColorShader::PhongVertexShader
ColorShader::PhongFragmentShader
```
