#include <string>
#include <vector>
#include <iostream>
struct node_body;
struct node_operator;
struct node_func_call;

struct node_args {
    std::string type;
    std::string var_name;
    int value;
    std::string int2_value;
    node_args(int flag, std::string * name) {
        if (flag == 1){
            type = "VARIABLE";
            var_name = *name; 
        }
        else {
            type = "INT2";
            int2_value = *name;
        }
    }
    node_args(int val) : type("VALUE"), value(val) {}
};



struct node_func_call  {
    std::string func_name;
    std::vector <node_args> args;
    node_func_call(std::string * name, std::vector <node_args> * args_) : func_name(*name), args(*args_) {}
};

struct node_literal  {
    std::string str;
    node_literal(std::string * str_) : str(*str_) {}
};


struct node_f {
        int value;
        std::string var_name;
        node_func_call * func_call;
        node_literal * literal;
        std::string int2_value;
    node_f(node_literal * literal_) : literal(literal_) {} 
    node_f(int v) : value(v) {}
    node_f(int flag, std::string * name){
        if (flag == 1){
            int2_value = *name;
        }
        if (flag == 2){
            var_name = *name;
        }
    }
    node_f(node_func_call * func) : func_call(func) {} 
};

struct node_o {
    std::string type;
    node_f * f;
    node_o * o;
    node_o(node_f * f_, node_o * o_) : type("DEGREE"), f(f_), o(o_) {}
    node_o(node_f * f_) : type("NOTHING"), f(f_), o(nullptr) {}
};

struct node_t {
    std::string type;
    node_o * o;
    node_t(char a, node_o * o_) : type("MINUS"), o(o_) {}
    node_t(node_o * o_) : type("NOTHING"), o(o_) {} 
};

struct node_q {
    std::string type;
    node_q * q;
    node_t * t;
    node_q(node_t * t_) : type("NOTHING"), t(t_) {}
    node_q(char op, node_q * q_, node_t * t_): q(q_), t(t_) {
        if (op == '*'){
            type = "MULT";
        }
        if (op == '/'){
            type = "DIV";
        }
    }
};

struct node_r {
    std::string type;
    node_r * r;
    node_q * q;
    node_r(node_q * q_) : r(nullptr), q(q_){}
    node_r(std::string * op, node_r * r_, node_q * q_) : r(r_), q(q_) {
        if (*op == "|+|"){
            type = "PLUS";
        }
        if (*op == "|-|"){
            type = "MINUS";
        }
    }
};

struct node_u {
    std::string type;
    node_r * r1;
    node_r * r2;
    node_u(std::string * op, node_r * r1_, node_r * r2_) : type(*op), r1(r1_), r2(r2_) {}
    node_u(node_r * r1_) : type("NOTHING"), r1(r1_) {} 
};

struct node_w { 
    std::string type;
    node_u * u;
    node_w(node_u * u_) : type("NOTHING"), u(u_) {}
    node_w(char op, node_u * u_) : type("UNARY MINUS"), u(u_) {}
};

struct node_e {
    std::string type;
    node_w * w;
    node_e * e;
    node_e(node_w * w_) : type("NOTHING"), e(nullptr), w(w_) {}
    node_e(std::string * op, node_w * w_, node_e * e_) : type("AND"), w(w_), e(e_) {}
};

struct node_m {
    std::string type;
    node_e * e;
    node_m * m;
    node_m(node_e * e_) : type("NOTHING"), e(e_), m(nullptr) {}
    node_m(std::string * op, node_e * e_, node_m * m_) : type("OR"), e(e_), m(m_) {}
};

struct node_operation {
    node_m * m;
    node_operation(node_m * m_) : m(m_) {}
};

struct node_expr {
    std::string type;
        node_literal *  literal;
        std::string var_name;
        node_func_call * func_call;
        node_operation * operation;
    node_expr(std::string * str) : var_name(*str) {}
    node_expr(node_literal * lit) : literal(lit) {}
    node_expr(node_func_call * func) : func_call(func) {}
    node_expr(node_operation * op) : operation(op) {}
}; 


struct if_op {
    node_expr * cond;
    node_body * body;
    node_body * n_else;
    if_op(node_expr * cond_, node_body * body_, node_body * else_) : cond(cond_), body(body_), n_else(else_) {}
};

struct while_op {
    node_expr * cond;
    node_body * body;
    while_op(node_expr * cond_, node_body * body_) : cond(cond_), body(body_) {}
};

struct skip_op {};

struct assignment_op {
    std::string name;
    node_expr * expr;
    assignment_op(std::string * name_, node_expr * expr_) : name(*name_), expr(expr_) {}
};

struct node_operator {
    std::string type;
    if_op * if_st;
    while_op * while_st;
    skip_op * skip_st;
    assignment_op * assign;
    node_func_call * func_call;
    node_operator(if_op * if_) : type("IF"), if_st(if_) {}
    node_operator(while_op * while_st_) : type("WHILE"), while_st(while_st_) {}
    node_operator(skip_op * skip_st_) : type("SKIP"), skip_st(skip_st_) {}
    node_operator(assignment_op * assign_) : type("ASSIGNMENT"), assign(assign_) {}
    node_operator(node_func_call * func_call_) : type("FUNCTION CALL"), func_call(func_call_) {} 
};

struct node_body {
    node_operator * first_op;
    std::vector <node_operator *> operators;
    node_body(node_operator * op, std::vector <node_operator *> * operators_) : first_op(op), operators(*operators_) {}
};


struct node_func {
    std::string name;
    std::vector <node_args> args;
    node_body * body;
    node_func(std::string * name_, std::vector <node_args> * args_, node_body * body_) : name(*name_), args(*args_), body(body_) {}
};

