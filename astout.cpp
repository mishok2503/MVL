#include "astout.h"

#include <string>
#include <utility>
#include <sstream>
#include <vector>
#include <optional>

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
    string out(string*);
    string out(int);
    string out(string*, bool);
    string out(node_literal*);
    string out(node_operation*);
    string out(node_m*);
    string out(node_e*);
    string out(node_w*);
    string out(node_u*);
    string out(node_r*);
    string out(node_q*);
    string out(node_t*);
    string out(node_o*);
    string out(node_f*);

    template<typename T>
    string out(const std::optional<T>& n) {
        return out(n.value());
    }

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
                ss << out(elem.first) << ": " << out(elem.second) << ',';
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
    
    string out(while_op* n) {
        return out_elem(
                pair{"type", "while"},
                pair{"condition", n->cond},
                pair{"if_branch", n->body});
    }
    
    string out(skip_op*) {
        return out_elem(pair{"type", "skip"});
    }
    
    string out(assignment_op* n) {
        return out_elem(
                pair{"type", "assignment"},
                pair{"left", &n->name},
                pair{"right", n->expr});
    }
    
    string out(node_func_call* n) {
        return out_elem(
                pair{"type", "function_call"},
                pair{"function", &n->func_name},
                pair{"arguments", &n->args});
    }

    string out(const node_args& n) {
        auto p = pair{"type", "argument"};
        switch (n.flag) {
            case 1:
                return out_elem(p, pair{"argument", n.var_name});
            case 2:
                return out_elem(p, pair{"argument", std::optional{*n.int2_value}});
            default:
                return out_elem(p, pair{"argument", std::optional{std::to_string(n.value)}});
        }
    }

    string out(node_expr* n) {
        return out(n->operation);
    }

    string out(string* n) {
        return out_elem(
                pair{"type", "name"},
                pair{"name", std::optional{*n}});
    }

    string out(node_literal* n) {
        return out_elem(
                pair{"type", "string"},
                pair{"value", std::optional{n->str}});
    }

    string out(node_operation* n) {
        return out_elem(
                pair{"type", "expression"},
                pair{"expression", n->m});
    }

    string out(node_m* n) {
        if (!n->m) {
            return out(n->e);
        }
        return out_elem(
                pair{"type", "||"},
                pair{"left", n->e},
                pair{"right", n->m});
    }

    string out(node_e* n) {
        if (!n->e) {
            return out(n->w);
        }
        return out_elem(
                pair{"type", "&&"},
                pair{"left", n->e},
                pair{"right", n->w});
    }

    string out(node_w* n) {
        if (n->empty) {
            return out(n->u);
        }
        return out_elem(
                pair{"type", "!"},
                pair{"expression", n->u});
    }

    string out(node_u* n) {
        if (!n->r2) {
            return out(n->r1);
        }
        return out_elem(
                pair{"type", std::optional{n->op}},
                pair{"left", n->r1},
                pair{"right", n->r2});
    }

    string out(node_r* n) {
        if (!n->r) {
            return out(n->q);
        }
        return out_elem(
                pair{"type", std::optional{n->op}},
                pair{"left", n->r},
                pair{"right", n->q});
    }

    string out(node_q* n) {
        if (!n->q) {
            return out(n->t);
        }
        return out_elem(
                pair{"type", std::optional{n->op}},
                pair{"left", n->q},
                pair{"right", n->t});
    }

    string out(node_t* n) {
        if (n->empty) {
            return out(n->o);
        }
        return out_elem(
                pair{"type", "unary-"},
                pair{"expression", n->o});
    }

    string out(node_o* n) {
        if (!n->o) {
            return out(n->f);
        }
        return out_elem(
                pair{"type", "^"},
                pair{"left", n->f},
                pair{"right", n->o});
    }

    string out(node_f* n) {
        if (n->literal) {
            return out(n->literal);
        }
        if (n->var_name) {
            return out(n->var_name);
        }
        if (n->int2_value) {
            return out(n->int2_value, true);
        }
        if (n->func_call) {
            return out(n->func_call);
        }
        return out(n->value);
    }

    string out(int n) {
        return out_elem(
                pair{"type", "int"},
                pair{"value", std::optional{std::to_string(n)}});
    }

    string out(string* str, bool) {
        return out_elem(
                pair{"type", "bin_int"},
                pair{"value", std::optional{*str}});
    }
}


std::string ast_out(std::vector<node_func*> funcs_defs, node_body* main_body) {
    return out_elem(pair{"main", main_body});
}
