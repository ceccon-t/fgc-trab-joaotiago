// Headers das bibliotecas OpenGL
#include <glad/glad.h>   // Criação de contexto OpenGL 3.3
#include <GLFW/glfw3.h>  // Criação de janelas do sistema operacional

// Headers da biblioteca GLM: criação de matrizes e vetores.
#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>

bool colidiuEsferaEsfera(glm::vec3 &posA, float radiusA, glm::vec3 &posB, float radiusB);

bool collidedPointSphere(glm::vec3 &posSphere, float radiusSphere, glm::vec3 &posPoint);

bool collidedSphereCube(glm::vec3 &centerSphere, float radiusSphere, glm::vec3 &centerCube, float halfFaceCube);
