#include "collisions.h"

bool collidedSphereSphere(glm::vec3 &posA, float radiusA, glm::vec3 &posB, float radiusB) {
    bool collided = false;

    float dist = glm::distance(posA, posB);

    if (dist < (radiusA + radiusB)) {
        collided = true;
    }

    return collided;
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

    collided = (closestPoint.x >= xmin && closestPoint.x <= xmax)
                && (closestPoint.y >= ymin && closestPoint.y <= ymax)
                && (closestPoint.z >= zmin && closestPoint.z <= zmax);

    return collided;
}
