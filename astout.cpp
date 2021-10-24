#include "astout.h"

#include <string>
#include <utility>
#include <sstream>
#include <vector>

namespace {

    template<typename... T>
    std::string out_elem(T ...elem) {
        std::stringstream ss;
        ss << '{';
        ((ss << '\"' << elem.first << "\": \"" << elem.second << "\","), ...);
        ss.seekp(-1, std::ios_base::end);
        ss << '}';
        return ss.str();
    }

//    string out(node_operator* op) {
//        sstream ss;
//
//
//        return ss.str();
//    }
//
//    string out(node_operator* fop, std::vector<node_operator*> ops) {
//        sstream ss;
//        ss << '[';
//        ss << out(fop);
//        for (const auto& op : ops) {
//            ss << ',' << out(op);
//        }
//        ss << ']';
//        return ss.str();
//    }
//
//    string out(node_body* n) {
//        sstream ss;
//        ss << '{';
//        ss << "\"type\": \"body\",";
//        ss << "\"operators\": " << out(n->first_op, n->operators);
//        ss << '}';
//        return ss.str();
//    }
}


std::string ast_out(std::vector<node_func*> funcs_defs, node_body* main_body) {
    return out_elem(std::pair{"asd", "dsa"}, std::pair{"ewq", "ert"});
//    std::stringstream ss;
//    ss << '{';
//    //ss << "\"functions\": " << out(funcs_defs);
//    ss << "\"main\": " << out(main_body);
//    ss << '}';
//    return ss.str();
}
