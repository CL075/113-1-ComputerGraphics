public void CGLine(float x1, float y1, float x2, float y2) {
  // TODO HW1
  // You need to implement the "line algorithm" in this section.
  // You can use the function line(x1, y1, x2, y2); to verify the correct answer.
  // However, remember to comment out before you submit your homework.
  // Otherwise, you will receive a score of 0 for this part.
  // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
  // coordinates (x, y).
  // For instance: drawPoint(114, 514, color(255, 0, 0)); signifies drawing a red
  // point at (114, 514).


  stroke(0);
  noFill();
  //line(x1,y1,x2,y2);


  int dx = Math.abs((int)x2 - (int)x1);
  int dy = Math.abs((int)y2 - (int)y1);

  int sx = (x1 < x2) ? 1 : -1;
  int sy = (y1 < y2) ? 1 : -1;

  int err = dx - dy;

  while (true) {
    drawPoint((int)x1, (int)y1, color(0));

    if (x1 == x2 && y1 == y2) break;

    int e2 = 2 * err;

    if (e2 > -dy) {
      err -= dy;
      x1 += sx;
    }
    if (e2 < dx) {
      err += dx;
      y1 += sy;
    }
  }
}

public void CGCircle(float x, float y, float r) {
  // TODO HW1
  // You need to implement the "circle algorithm" in this section.
  // You can use the function circle(x, y, r); to verify the correct answer.
  // However, remember to comment out before you submit your homework.
  // Otherwise, you will receive a score of 0 for this part.
  // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
  // coordinates (x, y).


  stroke(0);
  noFill();
  //circle(x,y,r*2);

  float x0 = 0;
  float y0 = r;
  float d = 1 - r;

  drawCirclePoints(x, y, x0, y0, color(0));

  while (x0 < y0) {
    if (d < 0) {
      d += 2 * x0 + 3;
    } else {
      d += 2 * (x0 - y0) + 5;
      y0--;
    }
    x0++;

    drawCirclePoints(x, y, x0, y0, color(0));
  }
}

public void CGEllipse(float x, float y, float r1, float r2) {
  // TODO HW1
  // You need to implement the "ellipse algorithm" in this section.
  // You can use the function ellipse(x, y, r1,r2); to verify the correct answer.
  // However, remember to comment out the function before you submit your homework.
  // Otherwise, you will receive a score of 0 for this part.
  // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
  // coordinates (x, y).


  stroke(0);
  noFill();
  //ellipse(x,y,r1*2,r2*2);

  float xPos = 0;
  float yPos = r2;
  float r1Squared = r1 * r1;
  float r2Squared = r2 * r2;

  float p1 = (float) (r2Squared - (r1Squared * r2) + (0.25 * r1Squared));
  while ((2 * r2Squared * xPos) < (2 * r1Squared * yPos)) {
    drawPoint(x + xPos, y + yPos, color(0));
    drawPoint(x - xPos, y + yPos, color(0));
    drawPoint(x + xPos, y - yPos, color(0));
    drawPoint(x - xPos, y - yPos, color(0));

    xPos++;

    if (p1 < 0) {
      p1 += (2 * r2Squared * xPos) + r2Squared;
    } else {
      yPos--;
      p1 += (2 * r2Squared * xPos) - (2 * r1Squared * yPos) + r2Squared;
    }
  }

  float p2 = (float) (r1Squared * (yPos - 0.5) * (yPos - 0.5) + r2Squared * (xPos + 0.5) * (xPos + 0.5) - r1Squared * r2Squared);
  while (yPos > 0) {
    drawPoint(x + xPos, y + yPos, color(0));
    drawPoint(x - xPos, y + yPos, color(0));
    drawPoint(x + xPos, y - yPos, color(0));
    drawPoint(x - xPos, y - yPos, color(0));

    yPos--;

    if (p2 > 0) {
      p2 += r1Squared - (2 * r1Squared * yPos);
    } else {
      xPos++;
      p2 += (2 * r2Squared * xPos) + r1Squared - (2 * r1Squared * yPos);
    }
  }
}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
  // TODO HW1
  // You need to implement the "bezier curve algorithm" in this section.
  // You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x,
  // p4.y); to verify the correct answer.
  // However, remember to comment out before you submit your homework.
  // Otherwise, you will receive a score of 0 for this part.
  // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
  // coordinates (x, y).


  stroke(0);
  noFill();
  //bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);


  float length1 = distance(p1, p2);
  float length2 = distance(p2, p3);
  float length3 = distance(p3, p4);

  float totalLength = length1 + length2 + length3;

  int numPoints = Math.max(1, (int)(totalLength * 5));

  for (int i = 0; i <= numPoints; i++) {
    float t = (float) i / numPoints;

    float x = (float) (Math.pow(1 - t, 3) * p1.x +
      3 * Math.pow(1 - t, 2) * t * p2.x +
      3 * (1 - t) * Math.pow(t, 2) * p3.x +
      Math.pow(t, 3) * p4.x);

    float y = (float) (Math.pow(1 - t, 3) * p1.y +
      3 * Math.pow(1 - t, 2) * t * p2.y +
      3 * (1 - t) * Math.pow(t, 2) * p3.y +
      Math.pow(t, 3) * p4.y);

    drawPoint(x, y, color(0));
  }
}

public void CGEraser(Vector3 p1, Vector3 p2) {
  // TODO HW1
  // You need to erase the scene in the area defined by points p1 and p2 in this
  // section.
  // p1 ------
  // |       |
  // |       |
  // ------ p2
  // The background color is color(250);
  // You can use the mouse wheel to change the eraser range.
  // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
  // coordinates (x, y).
  
  int backgroundColor = color(250);

    float xMin = Math.min(p1.x, p2.x);
    float xMax = Math.max(p1.x, p2.x);
    float yMin = Math.min(p1.y, p2.y);
    float yMax = Math.max(p1.y, p2.y);

    for (float x = xMin; x <= xMax; x++) {
        for (float y = yMin; y <= yMax; y++) {
            drawPoint(x, y, backgroundColor); 
        }
    }
}

public void drawPoint(float x, float y, color c) {
  stroke(c);
  point(x, y);
}

public void drawCirclePoints(float xc, float yc, float x, float y, color c) {
  drawPoint(xc + x, yc + y, color(0));  // 第一象限
  drawPoint(xc - x, yc + y, color(0));  // 第二象限
  drawPoint(xc + x, yc - y, color(0));  // 第四象限
  drawPoint(xc - x, yc - y, color(0));  // 第三象限
  drawPoint(xc + y, yc + x, color(0));  // 45 度角對稱
  drawPoint(xc - y, yc + x, color(0));
  drawPoint(xc + y, yc - x, color(0));
  drawPoint(xc - y, yc - x, color(0));
}

public float distance(Vector3 a, Vector3 b) {
  Vector3 c = a.sub(b);
  return sqrt(Vector3.dot(c, c));
}
