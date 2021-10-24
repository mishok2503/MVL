#include "astout.h"

#include <string>
#include <utility>
#include <sstream>
#include <vector>

namespace {

    using std::pair;
    using std::string;

    string out(const string& n) {
        return '\"' + n + '\"';
    }

    string out(node_body*);
    string out(node_operator*);
    string out(if_op*);
    string out(while_op*);
    string out(skip_op*);
    string out(assignment_op*);
    string out(node_func_call*);
    string out(node_expr*);

    template<typename T>
    string out(std::vector<T> *n) {
        std::stringstream ss;
        ss << '[';
        for (const auto& i : *n) {
            ss << out(i) << ',';
        }
        ss.seekp(-1, std::ios_base::end);
        ss << ']';
        return ss.str();
    }

    template<typename... T>
    string out_elem(T ...elem) {
        std::stringstream ss;
        ss << '{';
        ([&](const auto& e) {
            if (e.second) {
                ss << elem.first << ": " << out(elem.second) << ',';
            }
        }(elem), ...);
        ss.seekp(-1, std::ios_base::end);
        ss << '}';
        return ss.str();
    }

    string out(node_body* n) {
        auto v = std::vector{n->first_op};
        v.insert(v.end(), n->operators.begin(),  n->operators.end());
        return out_elem(
                pair{"type", "body"},
                pair{"operators", &v});
    }

    string out(node_operator* n) {
        string s = "operator";
        return out_elem(
                pair{"type", "operator"},
                pair{s, n->if_st}, //Only one will be not nullptr
                pair{s, n->while_st},
                pair{s, n->skip_st},
                pair{s, n->assign},
                pair{s, n->func_call});
    }

    string out(if_op* n) {
        return out_elem(
                pair{"type", "if"},
                pair{"condition", n->cond},
                pair{"if_branch", n->body},
                pair{"else_branch", n->n_else});
    }
    
    string out(while_op*) {
        return "REMOVEME";
    }
    
    string out(skip_op*) {
        return out_elem(pair{"type", "skip"});
    }
    
    string out(assignment_op*) {
        return "REMOVEME";
    }
    
    string out(node_func_call*) {
        return "REMOVEME";
    }

    string out(node_expr* n) {
        return "REMOVEME";
    }
}


std::string ast_out(std::vector<node_func*> funcs_defs, node_body* main_body) {
    return out_elem(pair{"main", main_body});
}
