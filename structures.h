#ifndef STRUCTURES_H
#define STRUCTURES_H
#include <string>
#include <vector>
#include <iostream>
struct node_body;
struct node_operator;
struct node_func_call;
struct node_expr;

struct node_args {
    node_expr * expr;
    node_args(node_expr * expr_) : expr(expr_) {}
};

struct node_custom_op {
    std::string * op;
    node_body * body;
    node_custom_op(std::string * op_, node_body * body_) : op(op_), body(body_){}
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
    std::string * var_name = nullptr;
    node_func_call * func_call = nullptr;
    node_literal * literal = nullptr;
    std::string * int2_value = nullptr;
    node_f(node_literal * literal_) : literal(literal_) {} 
    node_f(int v) : value(v) {}
    node_f(int flag, std::string * name){
        if (flag == 1){
            int2_value = name;
        }
        if (flag == 2){
            var_name = name;
        }
    }
    node_f(node_func_call * func) : func_call(func) {} 
};

struct node_o {
    node_f * f;
    node_o * o;
    std::string * op;
    node_o(std::string * op_, node_f * f_, node_o * o_) : op(op_), f(f_), o(o_) {}
    node_o(node_f * f_) : f(f_), o(nullptr) {}
};

struct node_t {
    bool empty = true;
    node_o * o;
    node_t(char a, node_o * o_) : o(o_), empty(false) {}
    node_t(node_o * o_) : o(o_) {} 
};

struct node_q {
    node_q * q = nullptr;
    node_t * t;
    std::string op;
    node_q(node_t * t_) : t(t_) {}
    node_q(std::string* op, node_q * q_, node_t * t_): q(q_), t(t_), op(*op) {
    }
};

struct node_r {
    node_r * r;
    node_q * q;
    std::string op;
    node_r(node_q * q_) : r(nullptr), q(q_){}
    node_r(std::string* op, node_r * r_, node_q * q_) : r(r_), q(q_), op(*op) {}
};

struct node_u {
    node_r * r1;
    node_r * r2 = nullptr;
    std::string op;
    node_u(std::string * op, node_r * r1_, node_r * r2_) : r1(r1_), r2(r2_), op(*op) {}
    node_u(node_r * r1_) : r1(r1_) {} 
};

struct node_w {
    bool empty = true;
    node_u * u;
    node_w(node_u * u_) : u(u_) {}
    node_w(char op, node_u * u_) : u(u_), empty(false) {}
};

struct node_e {
    node_w * w;
    node_e * e;
    node_e(node_w * w_) : e(nullptr), w(w_) {}
    node_e(std::string * op, node_w * w_, node_e * e_) : w(w_), e(e_) {}
};

struct node_m {
    node_e * e;
    node_m * m;
    node_m(node_e * e_) : e(e_), m(nullptr) {}
    node_m(std::string * op, node_e * e_, node_m * m_) : e(e_), m(m_) {}
};

struct node_operation {
    node_m * m;
    node_operation(node_m * m_) : m(m_) {}
};

struct node_expr {
    node_operation * operation = nullptr;
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
    if_op * if_st = nullptr;
    while_op * while_st = nullptr;
    skip_op * skip_st = nullptr;
    assignment_op * assign = nullptr;
    node_func_call * func_call;
    node_operator(if_op * if_) : if_st(if_) {}
    node_operator(while_op * while_st_) : while_st(while_st_) {}
    node_operator(skip_op * skip_st_) : skip_st(skip_st_) {}
    node_operator(assignment_op * assign_) : assign(assign_) {}
    node_operator(node_func_call * func_call_) : func_call(func_call_) {} 
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

#endif //STRUCTURES_H
