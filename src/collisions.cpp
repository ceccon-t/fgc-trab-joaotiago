#include "collisions.h"

bool colidiuEsferaEsfera(glm::vec3 &posA, float radiusA, glm::vec3 &posB, float radiusB) {
    bool colidiu = false;

    float dist = glm::distance(posA, posB);

    if (dist < (radiusA + radiusB)) {
        colidiu = true;
    }

    return colidiu;
}

bool collidedPointSphere(glm::vec3 &posSphere, float radiusSphere, glm::vec3 &posPoint) {
    bool collided = false;

    float dist = glm::distance(posSphere, posPoint);

    if (dist  < radiusSphere) {
        collided = true;
    }

    return collided;
}

// helper method
float normVec3(glm::vec3 v) {
    return sqrt(v.x * v.x + v.y * v.y +  v.z * v.z);
}

bool collidedSphereCube(glm::vec3 &centerSphere, float radiusSphere, glm::vec3 &centerCube, float halfFaceCube) {
    bool collided = false;

    glm::vec3 direction = centerCube - centerSphere;
    direction = direction / normVec3(direction);
    // glm::vec4 vec4Direction = glm::vec4(direction.x, direction.y, direction.z, 0.0f);
    // vec4Direction = vec4Direction / norm(vec4Direction);
    // vec4Direction *= radiusSphere; // we calculate vector towards closest point scaled by the radius


    // we get the point on the sphere that is the closest to the cube
    glm::vec3 closestPoint = glm::vec3(
        centerSphere.x + direction.x,
        centerSphere.y + direction.y,
        centerSphere.z + direction.z
    );

    // we get the boundaries of the cube
    // (and may the gods of geometry forgive us for treating a cube in a sphere-like way)
    float xmin = centerCube.x - halfFaceCube;
    float xmax = centerCube.x + halfFaceCube;
    float ymin = centerCube.y - halfFaceCube;
    float ymax = centerCube.y + halfFaceCube;
    float zmin = centerCube.z - halfFaceCube;
    float zmax = centerCube.z + halfFaceCube;

    collided = (centerSphere.x >= xmin && centerSphere.x <= xmax)
                && (centerSphere.y >= ymin && centerSphere.y <= ymax)
                && (centerSphere.z >= zmin && centerSphere.z <= zmax);

    return collided;
}


// if need to find center of sphere from origin of bounding box, try: vec3( x (+-) radius, y (+-) radius, z (+-) radius), I *think* some variation of this should work

