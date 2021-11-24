#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define SPHERE 0
#define BUNNY  1
#define PLANE  2
#define AIRCRAFT 3
#define WALL 4
#define GROUND 5
#define CELL 6
#define VIRUS 7
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;



// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;
uniform sampler2D TextureImage4;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec3 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Ponto que define a posição da fonte de luz, no centro da "caixa" formada pelos planos
    vec4 light_pos = vec4(50.0, 50.0, 50.0, 1.0);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(light_pos - p);

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);
    // Vetor que define o sentido da reflexão especular ideal.
    vec4 r = -l + 2*n*dot(n,l); 

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;
    
    vec3 I = vec3(1,1,1); // espectro da fonte de luz
    vec3 Ia = vec3(0.15,0.15,0.15); //  espectro da luz ambiente
    
    vec3 Ks; // Refletância especular
    vec3 Ka; // Refletância ambiente
    float q; // Expoente especular para o modelo de iluminação de Phong


    if ( object_id == VIRUS )
    {
    	//Lambert
        U = texcoords.x;
        V = texcoords.y;
        Ka = vec3(0.04,0.2,0.2);
        vec3 Kd = texture(TextureImage0, vec2(U,V)).rgb;
       	vec3 lambert_diffuse_term = Kd*I*max(0,dot(n,l));
        vec3 ambient_term = Ka*Ia; 
        color = lambert_diffuse_term + ambient_term;
        color = pow(color, vec3(1.0,1.0,1.0)/2.2);
    }
    else if ( object_id == SPHERE )
    {	
    	//lambert
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
        float theta = atan(position_model.x, position_model.z);
        float phi = asin(position_model.y / length(bbox_center - position_model));

        U = (theta + M_PI) / (2 * M_PI);
        V = (phi + M_PI_2) / M_PI;
        Ka = vec3(0.02,0.02,0.02);
   		vec3 Kd = texture(TextureImage4, vec2(U,V)).rgb;
        vec3 lambert_diffuse_term = Kd*I*max(0,dot(n,l));
        color = lambert_diffuse_term;
        color = pow(color, vec3(1.0,1.0,1.0)/2.2);
    }
    else if ( object_id == CELL )
    {	
    	//Lambert
        U = texcoords.x;
        V = texcoords.y;
        Ka = vec3(0.2,0.2,0.04); 
        vec3 Kd = texture(TextureImage3, vec2(U,V)).rgb;
        vec3 lambert_diffuse_term = Kd*I*max(0,dot(n,l));
        vec3 ambient_term = Ka*Ia; 
        color = lambert_diffuse_term + ambient_term;
        color = pow(color, vec3(1.0,1.0,1.0)/2.2); 
    }
    else if ( object_id == PLANE )
    {
    	//blinn-phong
        U = texcoords.x;
        V = texcoords.y;
        vec3 Kd = texture(TextureImage1, vec2(U,V)).rgb;
        Ks = vec3(0.5,0.5,0.5); 	 //refletancia especular da superf
        Ka = vec3(0.2,0.2,0.2);  	//refletancia ambiente da superf
        q = 25.0;
        vec4 sum = v+l;
        vec4 h = (sum) / sqrt(pow(sum.x,2)+pow(sum.y,2)+pow(sum.z,2));
        vec3 lambert_diffuse_term = Kd*I*max(0,dot(n,l));
        vec3 ambient_term = Ka*Ia;
        vec3 phong_specular_term = Ks*I*pow(max(0,dot(n,h)),q); 
        color = lambert_diffuse_term + ambient_term + phong_specular_term;
        color = pow(color, vec3(1.0,1.0,1.0)/2.2);
        
    }
    else if ( object_id == AIRCRAFT )
    {
    	//blinn-phong
        U = texcoords.x;
        V = texcoords.y;
        vec3 Kd = texture(TextureImage2, vec2(U,V)).rgb;
        Ks = vec3(0.8,0.8,0.8); 		 //refletancia especular da superf
        Ka = vec3(0.5,0.5,0.5);			//refletancia ambiente da superf
        q = 15.0;
        vec4 sum = v+l;
        vec4 h = (sum) / sqrt(pow(sum.x,2)+pow(sum.y,2)+pow(sum.z,2));
        vec3 lambert_diffuse_term = Kd*I*max(0,dot(n,l));
        vec3 ambient_term = Ka*Ia;
        vec3 phong_specular_term = Ks*I*pow(max(0,dot(n,h)),q); 
        color = lambert_diffuse_term + ambient_term + phong_specular_term;
        color = pow(color, vec3(1.0,1.0,1.0)/2.2);
        
    }

} 

