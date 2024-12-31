public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2
    // You need to check the coordinate p(x,v) if inside the vertexes. 

    //return false;

    int numVertices = vertexes.length;
    boolean inside = false;

    for (int i = 0, j = numVertices - 1; i < numVertices; j = i++) {
        float xi = vertexes[i].x;
        float yi = vertexes[i].y;
        float xj = vertexes[j].x;
        float yj = vertexes[j].y;

            if ((yi > y) != (yj > y)) { 
                float intersectX = (xj - xi) * (y - yi) / (yj - yi) + xi;
                if (x < intersectX) {
                    inside = !inside; 
                }
            }
    }

    return inside;

}

public Vector3[] findBoundBox(Vector3[] v) {
    Vector3 recordminV = new Vector3(1.0 / 0.0);
    Vector3 recordmaxV = new Vector3(-1.0 / 0.0);
    // TODO HW2
    // You need to find the bounding box of the vertexes v.

    if (v == null || v.length == 0) {
        return new Vector3[]{recordminV, recordmaxV};
    }

    for (int i = 0; i < v.length; i++) {
        Vector3 current = v[i];

        recordminV.x = Math.min(recordminV.x, current.x);
        recordminV.y = Math.min(recordminV.y, current.y);
        recordminV.z = Math.min(recordminV.z, current.z);

        recordmaxV.x = Math.max(recordmaxV.x, current.x);
        recordmaxV.y = Math.max(recordmaxV.y, current.y);
        recordmaxV.z = Math.max(recordmaxV.z, current.z);
    }

    Vector3[] result = { recordminV, recordmaxV };
    return result;
}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }

    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertexes of the "boundary".
    // The output is the vertexes of the polygon.

    //output = input;

    for (int j = 0; j < boundary.length; j++) {
        Vector3 edgeStart = boundary[j];
        Vector3 edgeEnd = boundary[(j + 1) % boundary.length];

        output.clear();

        for (int i = 0; i < input.size(); i++) {
            Vector3 current = input.get(i);
            Vector3 next = input.get((i + 1) % input.size());

            boolean currentInside = isInside(current, edgeStart, edgeEnd);
            boolean nextInside = isInside(next, edgeStart, edgeEnd);

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
        }

        input = new ArrayList<>(output);
    }

    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    return result;
}

private boolean isInside(Vector3 point, Vector3 edgeStart, Vector3 edgeEnd) {
    return (edgeEnd.x - edgeStart.x) * (point.y - edgeStart.y) - 
           (edgeEnd.y - edgeStart.y) * (point.x - edgeStart.x) <= 0;
}

private Vector3 calculateIntersection(Vector3 p1, Vector3 p2, Vector3 edgeStart, Vector3 edgeEnd) {
    float A1 = edgeEnd.y - edgeStart.y;
    float B1 = edgeStart.x - edgeEnd.x;
    float C1 = A1 * edgeStart.x + B1 * edgeStart.y;
    
    float A2 = p2.y - p1.y;
    float B2 = p1.x - p2.x;
    float C2 = A2 * p1.x + B2 * p1.y;

    float det = A1 * B2 - A2 * B1;
    if (det == 0) {
        return p1; 
    } 
    else {
        float x = (B2 * C1 - B1 * C2) / det;
        float y = (A1 * C2 - A2 * C1) / det;
        return new Vector3(x, y, 0);
    }
}

public float getDepth(float x, float y, Vector3[] vertex) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;

    //return 0.0;

    Vector3 A = vertex[0];
    Vector3 B = vertex[1];
    Vector3 C = vertex[2];

    float triangleArea = Math.abs((B.x - A.x) * (C.y - A.y) - (C.x - A.x) * (B.y - A.y));

    if (triangleArea == 0) {
        return 0.0f; 
    }

    float areaPBC = Math.abs((B.x - x) * (C.y - y) - (C.x - x) * (B.y - y));
    float areaPCA = Math.abs((C.x - x) * (A.y - y) - (A.x - x) * (C.y - y));
    float areaPAB = Math.abs((A.x - x) * (B.y - y) - (B.x - x) * (A.y - y));

    float alpha = areaPBC / triangleArea; 
    float beta = areaPCA / triangleArea; 
    float gamma = areaPAB / triangleArea;

    float depth = alpha * A.z + beta * B.z + gamma * C.z;

    return Math.max(0.0f, Math.min(1.0f, depth));
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    Vector4 AW = verts[0];
    Vector4 BW = verts[1];
    Vector4 CW = verts[2];

    // TODO HW4
    // Calculate the barycentric coordinates of point P in the triangle verts using
    // the barycentric coordinate system.
    // Please notice that you should use Perspective-Correct Interpolation otherwise
    // you will get wrong answer.

    // 計算三角形的總面積
    float areaABC = Math.abs((B.x - A.x) * (C.y - A.y) - (C.x - A.x) * (B.y - A.y));

    if (areaABC == 0) {
        return new float[]{0.0f, 0.0f, 0.0f}; // 避免除以零的情況
    }

    // 計算三個子三角形的面積
    float areaPBC = Math.abs((B.x - P.x) * (C.y - P.y) - (C.x - P.x) * (B.y - P.y));
    float areaPCA = Math.abs((C.x - P.x) * (A.y - P.y) - (A.x - P.x) * (C.y - P.y));
    float areaPAB = Math.abs((A.x - P.x) * (B.y - P.y) - (B.x - P.x) * (A.y - P.y));

    // 計算未經校正的重心坐標
    float alpha = areaPBC / areaABC;
    float beta = areaPCA / areaABC;
    float gamma = areaPAB / areaABC;

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

    // 將結果存入 result
    float[] result = {alpha, beta, gamma};

    //float[] result = { 0.0, 0.0, 0.0 };

    return result;
}

Vector3 interpolation(float[] abg, Vector3[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

Vector4 interpolation(float[] abg, Vector4[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

float interpolation(float[] abg, float[] v) {
    return v[0] * abg[0] + v[1] * abg[1] + v[2] * abg[2];
}
