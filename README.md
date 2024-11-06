# Lab2

## Which tasks you have completed
(如果GitHub底色是深色可能會看不到數學公式)
### Translation Matrix
```
Matrix4::makeTrans(Vector3 t)
```
平移矩陣為：
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/trans.svg)
，其中![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/txtytz.svg)則代表的是他們所移動的單位。  
<br>
且我們一開始有設一個基礎的矩陣為：
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/identity.svg)
，由左至右，由上至下，分別將他從m[0]至m[15]依序編號。  
<br>
所以我們可以透過
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/setTrans.svg)
將基礎矩陣變成平移矩陣，以此來達到移動圖形的目的。


### Scaling Matrix
```
Matrix4::makeScale(Vector3 s)
```
同理，縮放矩陣為：
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/scale.svg)

所以我們透過
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/setScale.svg)
可達到縮放圖形的目的。

### Rotation Matrix (Z-axis)
```
Matrix4::makeRotZ(float a)
```
繞x矩陣：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_x.svg)，修改m[5]、m[6]、m[9]、m[10]
<br> 
<br>
繞y矩陣：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_y.svg)，修改m[0]、m[2]、m[8]、m[10]

繞z矩陣：
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_z.svg)，修改m[0]、m[1]、m[4]、m[5]
<br>
(也是我們在這個實作中實際可以看到的旋轉矩陣)
<br>
<br>
一樣都是透過那個基礎的矩陣，將對應的位置改成跟旋轉矩陣相同，以此來實現圖形的旋轉。


### Is the point inside a shape?
```
util::pnpoly(float x, float y, Vector3[] vertexes)
```
設定變數：
```
int numVertices = vertexes.length; // 用來記錄多邊形頂點的數量
boolean inside = false; // 儲存狀態：現在是否在多邊形內
```
檢查多邊形的每一條邊：
```
for (int i = 0, j = numVertices - 1; i < numVertices; j = i++) {
    float xi = vertexes[i].x; // 現在頂點 i 的 x 座標
    float yi = vertexes[i].y; // 現在頂點 i 的 y 座標
    float xj = vertexes[j].x; // 上一個頂點 j 的 x 座標
    float yj = vertexes[j].y; // 上一個頂點 j 的 y 座標
```
檢查從點 (x, y) 發出的水平射線是否與多邊形的某一邊相交：
```
if ((yi > y) != (yj > y)) {  // 透過這兩個條件來判斷射線是否與邊相交
                // 無相交的話，直接跳到最底下的return inside去回覆當前狀態。

    // 若有相交，可透過下算式求出交點的x座標
    float intersectX = (xj - xi) * (y - yi) / (yj - yi) + xi;

    // 如果計算出來的交點在點的右側，那麼我們就知道射線穿過了這條邊
    if (x < intersectX) {  
        inside = !inside;  // 我們可以把我們的狀態取反
    }
}

return inside; // 回覆當前儲存的狀態
```

### Find the boundary of a polygon
```
util::findBoundBox(Vector3[] v) 
```
檢查輸入的有效性：
```
// 如果v是 null 或者 長度是0 的時候，他會返回初始值
if (v == null || v.length == 0) {
    return new Vector3[]{recordminV, recordmaxV};
}
```
遍歷所有的頂點：
```
for (int i = 0; i < v.length; i++) {
    Vector3 current = v[i];  // 取出當前頂點
```

對於每個當前頂點(current)，透過Math.min( )和Math.max( )來更新最小和最大邊界：
```
//最小邊界(所有點中最小的x, y, z值，代表邊界框的左下角)
recordminV.x = Math.min(recordminV.x, current.x);
recordminV.y = Math.min(recordminV.y, current.y);
recordminV.z = Math.min(recordminV.z, current.z);

//最大邊界(所有點中最大的x, y, z值，代表邊界框的右上角)
recordmaxV.x = Math.max(recordmaxV.x, current.x);
recordmaxV.y = Math.max(recordmaxV.y, current.y);
recordmaxV.z = Math.max(recordmaxV.z, current.z);
```

返回邊界框
```
Vector3[] result = { recordminV, recordmaxV };
return result;
```

### Keep the polygon inside the canvas
```
util::Sutherland_Hodgman_algorithm(Vector3[] points,Vector3[] boundary)
```

## Some screenshots of your work
![image]()
![image]()
![image]()
![svg]()
![svg]()
![svg]()

## How you completed these tasks

