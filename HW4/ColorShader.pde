public class PhongVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }

        Vector4[][] result = { gl_Position, w_position, w_normal };

        return result;
    }
}

public class PhongFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 position = (Vector3) varying[0];
        Vector3 w_position = (Vector3) varying[1];
        Vector3 w_normal = (Vector3) varying[2];
        Vector3 albedo = (Vector3) varying[3];
        Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        Camera cam = main_camera;

        // TODO HW4
        // In this section, we have passed in all the variables you need.
        // Please use these variables to calculate the result of Phong shading
        // for that point and return it to GameObject for rendering


        Vector3 lightDir = light.transform.position.sub(w_position);
        lightDir.normalize();

        Vector3 viewDir = (cam.transform.position.sub(w_position));
        viewDir.normalize();

        Vector3 reflectDir = w_normal.reflect(lightDir);
        reflectDir.normalize();

        Vector3 ambientComponent = albedo.mult(0.5f); 

        float diffuse = Math.max(Vector3.dot(w_normal, lightDir), 0.0); 
        Vector3 diffuseComponent = albedo.mult(kdksm.x * diffuse * light.intensity); 

        float specular = (float) Math.pow(Math.max(Vector3.dot(viewDir, reflectDir), 0.0), kdksm.z);
        Vector3 specularComponent = new Vector3(1.0, 1.0, 1.0).mult(kdksm.y * specular * light.intensity); 

        Vector3 colors = ambientComponent.add(diffuseComponent).add(specularComponent);

        return new Vector4(colors.x, colors.y, colors.z, 1.0);

        //return new Vector4(0.0, 0.0, 0.0, 1.0);
    }
}

public class FlatVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 modelMatrix = (Matrix4) uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];

        // TODO HW4
        // Here you have to complete Flat shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note: Here the first variable must return the position of the vertex.
        // Subsequent variables will be interpolated and passed to the fragment shader.
        // The return value must be a Vector4.

        // 計算三角形的面法線
        Vector3 edge1 = aVertexPosition[1].sub(aVertexPosition[0]);
        Vector3 edge2 = aVertexPosition[2].sub(aVertexPosition[0]);
        Vector3 faceNormal = Vector3.cross(edge1, edge2);
        faceNormal.normalize(); // 計算並歸一化法線

        for (int i = 0; i < gl_Position.length; i++) {
            w_position[i] = modelMatrix.mult(aVertexPosition[i].getVector4(1.0));
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
        }

        // 將法線作為輸出傳遞
        Vector4 faceNormalOutput = faceNormal.getVector4(0.0); // 將 Vector3 轉換為 Vector4

        Vector4[][] result = { gl_Position, w_position, { faceNormalOutput } };

        return result;
    }
}

public class FlatFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        //Vector3 position = (Vector3) varying[0];
        Vector3 faceNormal = ((Vector4) varying[2]).xyz(); // 面法線
        Vector3 w_position = ((Vector4) varying[1]).xyz();
        //Vector3 albedo = (Vector3) varying[0];
        Vector3 albedo = new Vector3(1.0, 0.5, 0.3);
        Camera cam = main_camera;
        //Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        // TODO HW4
        // Here you have to complete Flat shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note : In the fragment shader, the first 'varying' variable must be its
        // screen position.
        // Subsequent variables will be received in order from the vertex shader.
        // Additional variables needed will be passed by the material later.

        //Vector3 normal = varying[1].getVector3(); // Assuming varying[1] is where normal is passed
        //Vector3 normal = (Vector3) varying[1];

        Vector3 lightDir = light.transform.position.sub(w_position); // 光源方向
        lightDir.normalize();

        float diffuse = Math.max(Vector3.dot(faceNormal, lightDir), 0.0);
        println("Diffuse: " + diffuse); // 調試輸出

        Vector3 colors = albedo.mult(diffuse * light.intensity);

        return new Vector4(colors.x, colors.y, colors.z, 1.0);

        //return new Vector4(0.0, 0.0, 0.0, 1.0);
    }
}

public class GouraudVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Matrix4 MVP = (Matrix4) uniform[0];
        Vector3[] normal = (Vector3[]) uniform[1];
        Vector3 lightDir = basic_light.transform.position;
        lightDir.normalize();

        Vector4[] gl_Position = new Vector4[3];
        Vector3[] vertexColors = new Vector3[3];

        // TODO HW4
        // Here you have to complete Gouraud shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note: Here the first variable must return the position of the vertex.
        // Subsequent variables will be interpolated and passed to the fragment shader.
        // The return value must be a Vector4.

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));

            float intensity = Math.max(Vector3.dot(normal[i], lightDir), 0.0);

            vertexColors[i] = new Vector3(intensity, intensity, intensity);
        }

        //Vector4[][] result = { gl_Position };

        Vector4[] vertexColors4 = new Vector4[3];
        for (int i = 0; i < vertexColors.length; i++) {
            vertexColors4[i] = vertexColors[i].getVector4(1.0);  // 添加 1.0 以将 Vector3 转换为 Vector4
        }
        Vector4[][] result = { gl_Position, vertexColors4 };

        //Vector4[][] result = { gl_Position, vertexColors };

        return result;
    }
}

public class GouraudFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 position = (Vector3) varying[0];

        // TODO HW4
        // Here you have to complete Gouraud shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note : In the fragment shader, the first 'varying' variable must be its
        // screen position.
        // Subsequent variables will be received in order from the vertex shader.
        // Additional variables needed will be passed by the material later.

        Vector3 colors = (Vector3) varying[1];
        return new Vector4(colors.x, colors.y, colors.z, 1.0);

        //return new Vector4(0.0, 0.0, 0.0, 1.0);
    }
}
