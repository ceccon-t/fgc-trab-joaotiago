#include "collisions.h"

bool colidiuEsferaEsfera(glm::vec3 &posA, float radiusA, glm::vec3 &posB, float radiusB) {
    bool colidiu = false;

    float dist = glm::distance(posA, posB);

    if (dist < (radiusA + radiusB)) {
        colidiu = true;
    }

    return colidiu;
}

