public class Camera {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    Matrix4 viewMatrix = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    Transform transform;


    public void rotate(float angle, Vector3 axis) {
        Matrix4 rotation = new Matrix4();
        rotation.makeRotation(angle, axis);

        // 確保 viewMatrix 不為 null
        if (viewMatrix == null) {
            viewMatrix = new Matrix4();
            viewMatrix.makeIdentity();
        }

        // 將旋轉矩陣應用到 viewMatrix
        viewMatrix = viewMatrix.mult(rotation);
    }

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        viewMatrix.makeIdentity();
        transform = new Transform();
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        
        // TODO HW3
        // This function takes four parameters, which are 
        // the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.

        projection = Matrix4.Identity();

        float aspectRatio = (float)w / (float)h;
    
        // 設置投影矩陣為透視投影
        projection.m[0] = 1.0f / (aspectRatio * (float)Math.tan(Math.toRadians(GH_FOV / 2.0f)));
        projection.m[5] = 1.0f / (float)Math.tan(Math.toRadians(GH_FOV / 2.0f));
        projection.m[10] = (far + near) / (near - far);
        projection.m[11] = (2.0f * far * near) / (near - far);
        projection.m[14] = -1.0f;
        projection.m[15] = 0.0f;

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {

    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.

        //worldView = Matrix4.Identity();

        // 1. 計算視點向量
        Vector3 topVector = new Vector3(0, 1, 0);  // 定義上向量

        Vector3 forward = lookat.sub(pos);   // 計算朝向向量
        forward.normalize();  // 正規化這個向量
        
        Vector3 right = Vector3.cross(topVector, forward);   // 計算右向量
        right.normalize();  // 正規化右向量
        
        Vector3 up = Vector3.cross(right, forward);
        up.normalize();
        
        // 2. 建立視圖矩陣（也可以稱為視野矩陣）
        worldView = Matrix4.Identity();
        
        // 將右、上、前向量設置到矩陣中
        worldView.m[0] = right.x;
        worldView.m[1] = right.y;
        worldView.m[2] = right.z;
        
        worldView.m[4] = up.x;
        worldView.m[5] = up.y;
        worldView.m[6] = up.z;
        
        worldView.m[8] = -forward.x;
        worldView.m[9] = -forward.y;
        worldView.m[10] = -forward.z;
        
        // 3. 設置相機位置
        worldView.m[12] = -pos.x;
        worldView.m[13] = -pos.y;
        worldView.m[14] = -pos.z;
    
    }


}
