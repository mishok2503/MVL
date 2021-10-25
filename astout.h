#ifndef ASTOUT_H
#define ASTOUT_H

#include <string>
#include <vector>
#include "structures.h"

std::string ast_out(std::vector<node_func*> funcs_defs, node_body* main_body);

#endif //ASTOUT_H
