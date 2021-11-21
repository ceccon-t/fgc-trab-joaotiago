#include "collisions.h"

bool colidiuEsferaEsfera(glm::vec3 &posA, float radiusA, glm::vec3 &posB, float radiusB) {
    bool colidiu = false;

    float dist = glm::distance(posA, posB);

    if (dist < (radiusA + radiusB)) {
        colidiu = true;
    }

    return colidiu;
}


// if need to find center of sphere from origin of bounding box, try: vec3( x (+-) radius, y (+-) radius, z (+-) radius), I *think* some variation of this should work

