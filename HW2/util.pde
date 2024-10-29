public void CGLine(float x1, float y1, float x2, float y2) {
  // TODO HW1
  // Please paste your code from HW1 CGLine.
  stroke(0);
  noFill();
  line(x1,y1,x2,y2);

  int xStart = Math.round(x1);
  int yStart = Math.round(y1);
  int xEnd = Math.round(x2);
  int yEnd = Math.round(y2);

  int dx = Math.abs(xEnd - xStart);
  int dy = Math.abs(yEnd - yStart);
  int sx = (xStart < xEnd) ? 1 : -1;
  int sy = (yStart < yEnd) ? 1 : -1;
  int err = dx - dy;

  int maxSteps = dx + dy;
  for (int i = 0; i <= maxSteps; i++) {
      drawPoint(xStart, yStart, color(0));

      if (xStart == xEnd && yStart == yEnd) break;

      int e2 = 2 * err;
      if (e2 > -dy) {
          err -= dy;
          xStart += sx;
      }
      if (e2 < dx) {
          err += dx;
          yStart += sy;
      }
  }
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
  // You need to check the coordinate p(x,v) if inside the vertices.
  // If yes return true, vice versa.

  return false;
}

public Vector3[] findBoundBox(Vector3[] v) {


  // TODO HW2
  // You need to find the bounding box of the vertices v.
  // r1 -------
  //   |   /\  |
  //   |  /  \ |
  //   | /____\|
  //    ------- r2

  Vector3 recordminV = new Vector3(0);
  Vector3 recordmaxV = new Vector3(999);

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
  // And the other is the vertices of the "boundary".
  // The output is the vertices of the polygon.

  output = input;

  Vector3[] result = new Vector3[output.size()];
  for (int i = 0; i < result.length; i += 1) {
    result[i] = output.get(i);
  }
  return result;
}
