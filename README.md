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

對於每個當前頂點```current```，透過```Math.min()```和```Math.max()```來更新最小和最大邊界：
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

初始化```input```和```output```，並將```points```加到```input```裡面
```
ArrayList<Vector3> input = new ArrayList<Vector3>();
ArrayList<Vector3> output = new ArrayList<Vector3>();

for (int i = 0; i < points.length; i += 1) {
  input.add(points[i]);
}
```

對每條邊界進行剪裁
```
//使用 boundary 多邊形中的每一對連續頂點
for (int j = 0; j < boundary.length; j++) {

    //定義一條邊的 edgeStart 到 edgeEnd
    Vector3 edgeStart = boundary[j];
    Vector3 edgeEnd = boundary[(j + 1) % boundary.length];
    
    output.clear();  // 清空輸出列表，每次儲存新結果
```

遍歷多邊形的每條邊來進行剪裁的判斷
```
for (int i = 0; i < input.size(); i++) {

    // current 和 next 表示多邊形中的相鄰兩個頂點
    Vector3 current = input.get(i);
    Vector3 next = input.get((i + 1) % input.size());
```

使用```isInside```判斷點是否位於邊界內部
```
boolean currentInside = isInside(current, edgeStart, edgeEnd);
boolean nextInside = isInside(next, edgeStart, edgeEnd);
```
```isInside```：<br>
透過向量的cross product來判斷點是否位於邊的內部。
<br>
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/vector.svg)
<br>
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/cross.svg)
<br>
當結果為「非正」時，代表```point```位於```edgeStart```和```edgeEnd```的內側
```
private boolean isInside(Vector3 point, Vector3 edgeStart, Vector3 edgeEnd) {
    return (edgeEnd.x - edgeStart.x) * (point.y - edgeStart.y) - 
           (edgeEnd.y - edgeStart.y) * (point.x - edgeStart.x) <= 0;
}

```

根據內外判斷決定剪裁行為
```
if (currentInside && nextInside) {
    output.add(next);
} 
else if (currentInside) {
    output.add(calculateIntersection(current, next, edgeStart, edgeEnd));
} 
else if (nextInside) {
    output.add(calculateIntersection(current, next, edgeStart, edgeEnd));
    output.add(next);
}
```
總共會有四種情況：
- 兩個點都在內部：直接將```next```加入```output```
- ```current```在內部但```next```在外部：計算邊的交點並加入```output```
- ```current```在外部但```next```在內部：先加入交點，再加入```next```
- 兩個點都在外部：不加入任何點

```calculateIntersection```：
<br>
用來計算兩條直線 ```p1-p2``` 和 ```edgeStart-edgeEnd``` 的交點位置

```
private Vector3 calculateIntersection(Vector3 p1, Vector3 p2, Vector3 edgeStart, Vector3 edgeEnd) {

    // A B C 為計算直線線性方程式的參數
    float A1 = edgeEnd.y - edgeStart.y;
    float B1 = edgeStart.x - edgeEnd.x;
    float C1 = A1 * edgeStart.x + B1 * edgeStart.y;
    
    float A2 = p2.y - p1.y;
    float B2 = p1.x - p2.x;
    float C2 = A2 * p1.x + B2 * p1.y;

    // 使用行列式 det 判斷是否平行
    float det = A1 * B2 - A2 * B1;

    // 若平行，則無交點，直接返回 p1
    if (det == 0) {
        return p1; 
    } 

    // 若非平行，則使用行列式公式求出交點的 (x, y) 座標
    else {
        float x = (B2 * C1 - B1 * C2) / det;
        float y = (A1 * C2 - A2 * C1) / det;
        return new Vector3(x, y, 0);
    }
}
```
將```output```中的頂點複製到```input```，準備進行下一條邊的剪裁
```
input = new ArrayList<>(output);
```

返回剪裁後的結果
```
Vector3[] result = new Vector3[output.size()];
for (int i = 0; i < result.length; i++) {
    result[i] = output.get(i);
}
return result;
```

## Some screenshots of your work
![image]()
![image]()
![image]()

## How you completed these tasks

