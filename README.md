# Lab2

## Which tasks you have completed

### Translation Matrix
```
Matrix4::makeTrans(Vector3 t)
```
平移矩陣為：
![]("https://raw.githack.com/CL075/113-1-ComputerGraphics/Lab2/math_image/trans.svg")

其中(tx, ty, tz)則代表的是他們所移動的單位。  
<br>
且我們一開始有設一個基礎的矩陣為：
![]("https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/identity.svg")  

由左至右，由上至下，分別將他從m[0]~m[15]依序編號。  
<br>
所以我們可以透過
![]("https://github.com/CL075/113-1-ComputerGraphics/blob/Lab2/math_image/setTrans.svg")

將基礎矩陣變成平移矩陣，以此來達到移動圖形的目的。




### Rotation Matrix (Z-axis)
```
Matrix4::makeRotZ(float a)
```



### Scaling Matrix
```
Matrix4::makeScale(Vector3 s)
```

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

