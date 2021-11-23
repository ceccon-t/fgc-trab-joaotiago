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

// if need to find center of sphere from origin of bounding box, try: vec3( x (+-) radius, y (+-) radius, z (+-) radius), I *think* some variation of this should work

