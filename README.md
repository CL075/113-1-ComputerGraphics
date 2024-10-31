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
繞y矩陣：![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_y.svg)，修改m[0]、m[2]、m[8]、m[10]

繞z矩陣(也是我們在這個實作中實際可以看到的旋轉矩陣)：
![svg](https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/R_z.svg)，修改m[0]、m[1]、m[4]、m[5]

一樣是透過那個基礎的矩陣，將對應的位置改成跟旋轉矩陣相同。

![svg]()
![svg]()
![svg]()



### Is the point inside a shape?
```
util::pnpoly(float x, float y, Vector3[] vertexes)
```

### Find the boundary of a polygon
```
util::findBoundBox(Vector3[] v) 
```

### Keep the polygon inside the canvas
```
util::Sutherland_Hodgman_algorithm(Vector3[] points,Vector3[] boundary)
```

## Some screenshots of your work
![image]()
![image]()
![image]()

## How you completed these tasks

