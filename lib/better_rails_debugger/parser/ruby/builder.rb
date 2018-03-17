class Builder < ::Parser::Builders::Default
  # Name => Array<Signal block>
  @@subscriptions = Hash.new(Hash.new)

  # Call all subscriptions for the given signal
  # @param signal_name Symbol
  # @param args Hash
  def self.emit_signal(signal_name, args)
    @@subscriptions[signal_name].values.each do |block|
      block.call(args)
    end
  end

  # Subscribe to a particular signal
  # @param signal_name Symbol
  # @param block Proc
  def self.subscribe_signal(signal_name, &block)
    key = SecureRandom.hex(5)
    @@subscriptions[signal_name][key] = block
    key
  end

  # Overwrite Default builder methods to send signal

  #
  # Literals
  #

  # Singletons

  def nil(nil_t)
    emit_signal(:nil, (nil_t: nil_t))
    super
  end

  def true(true_t)
    emit_signal(:true, {true_t: true_t})
    super
  end

  def false(false_t)
    emit_signal(:false, {false_t: false_t})
    super
  end

  # Numerics

  def integer(integer_t)
    emit_signal(:iteger, {integer_t: integer_t})
    super
  end

  def float(float_t)
    emit_signal(:float, {float_t: float_t})
    super
  end

  def rational(rational_t)
    emit_signal(:rational, {rational_t: rational_t})
    super
  end

  def complex(complex_t)
    emit_signal(:complex, {complex_t: complex_t})
    super
  end

  def numeric(kind, token)
    emit_signal(:numeric, {kind: kind, token: token})
    super
  end

  def unary_num(unary_t, numeric)
    emit_signal(:unary_num, {unary_t: unary_t, numeric: numeric})
    super
  end

  def __LINE__(__LINE__t)
    emit_signal(:__LINE__, {__LINE__t: __LINE__t})
    super
  end

  # Strings

  def string(string_t)
    emit_signal(:string, {string_t: string_t})
    super
  end

  def string_internal(string_t)
    emit_signal :string_internal, {string_t: string_t}
    super
  end

  def string_compose(begin_t, parts, end_t)
    emit_signal :string_compose {begin_t: begin_t, part: part, end_t: end_t}
    super
  end

  def character(char_t)
    emit_signal :character, {char_t: char_t}
    super
  end

  def __FILE__(__FILE__t)
    emit_signal :__FILE__, {__FILE__t: __FILE__t}
    super
  end

  # Symbols

  def symbol(symbol_t)
    emit_signal :symbol, {symbol_t: symbol_t}
    super
  end

  def symbol_internal(symbol_t)
    emit_signal :symbol_internal, {symbol_t: symbol_t}
    super
  end

  def symbol_compose(begin_t, parts, end_t)
    emit_signal :symbol_compose, {begin_t: begin_t, parts: parts, end_t: end_t}
    super
  end

  # Executable strings

  def xstring_compose(begin_t, parts, end_t)
    emit_signal :xstring_compose, {begin_t: begin_t, parts: parts, end_t: end_t}
    super
  end

  # Indented (interpolated, noninterpolated, executable) strings

  def dedent_string(node, dedent_level)
    emit_signal :dedent_string, {node: node, dedent_level: dedent_level}
    super
  end

  # Regular expressions

  def regexp_options(regopt_t)
    emit_signal :regexp_options, {regopt_t: regopt_t}
  end

  def regexp_compose(begin_t, parts, end_t, options)
    emit_signal :regexp_compose, {begin_t: begin_t, end_t: end_t, options: options}
    super
  end

  # Arrays

  def array(begin_t, elements, end_t)
    emit_signal :array, {begin_t: begin_t, elements: elements, end_t: end_t}
    super
  end

  def splat(star_t, arg=nil)
    emit_signal :splat, {start_t: start_t, arg: arg}
    super
  end

  def word(parts)
    emit_signal :word, {parts: parts}
    super
  end

  def words_compose(begin_t, parts, end_t)
    emit_signal :words_compose, {begin_t: begin_t, parts: parts, end_t: end_t}
    super
  end

  def symbols_compose(begin_t, parts, end_t)
    emit_signal :symbols_compose, {begin_t: begin_t, parts: parts, end_t: end_t}
    super
  end

  # Hashes

  def pair(key, assoc_t, value)
    emit_signal :pair, {key: key, assoc_t: assoc_t, value: value}
    super
  end

  def pair_list_18(list)
    # Omit ruby 1.8
    super
  end

  def pair_keyword(key_t, value)
    emit_signal :pair_keyword, {key_t: key_t, value: value}
    super
  end

  def pair_quoted(begin_t, parts, end_t, value)
    emit_signal :pair_quoted, {begin_t: begin_t, parts: parts, end_t: end_t, value: value}
    super
  end

  def kwsplat(dstar_t, arg)
    emit_signal :kwsplat, {dstar_t: dstar_t, arg: arg}
    super
  end

  def associate(begin_t, pairs, end_t)
    emit_signal :associate, {begin_t: begin_t, parts: parts, end_t: end_t}
    super
  end

  # Ranges

  def range_inclusive(lhs, dot2_t, rhs)
    emit_signal :range_inclusive, {lhs: lhs, dot2_t: dot2_t, rhs: rhs}
    super
  end

  def range_exclusive(lhs, dot3_t, rhs)
    emit_signal :range_exclusive, {lhs: lhs, dot3_t: dot3_t, rhs: rhs}
    super
  end

  #
  # Access
  #

  def self(token)
    emit_signal :self, {token: token}
    super
  end

  def ident(token)
    emit_signal :ident, {token: token}
    super
  end

  def ivar(token)
    emit_signal :ivar, {token: token}
    super
  end

  def gvar(token)
    emit_signal :gvar, {token: token}
    super
  end

  def cvar(token)
    emit_signal :cvar, {token: token}
    super
  end

  def back_ref(token)
    emit_signal :back_ref, {token: token}
    super
  end

  def nth_ref(token)
    emit_signal :nth_ref, {token: token}
    super
  end

  def accessible(node)
    emit_signal :accessible, {node: node}
    super
  end

  def const(name_t)
    emit_signal :const, {name_t: name_t}
    super
  end

  def const_global(t_colon3, name_t)
    emit_signal const_global {t_colon3: t_colon3, name_t: name_t}
    super
  end

  def const_fetch(scope, t_colon2, name_t)
    emit_signal :const_fetch, {scope: scope, t_colon2: t_colon2, name_t: name_t}
    super
  end

  def __ENCODING__(__ENCODING__t)
    emit_signal :__ENCODING__, {__ENCODING__t: __ENCODING__t}
    super
  end

  #
  # Assignment
  #

  def assignable(node)
    emit_signal :assignable, {node: node}
    super
  end

  def const_op_assignable(node)
    emit_signal :const_op_assignable, {node: node}
    super
  end

  def assign(lhs, eql_t, rhs)
    emit_signal :assign, {lhs: lhs, eql_t: eql_t, rhs: rhs}
    super
  end

  def op_assign(lhs, op_t, rhs)
    emit_signal :op_assign, {lhs: lhs, op_t: op_t, rhs: rhs}
    super
  end

  def multi_lhs(begin_t, items, end_t)
    emit_signal :multi_lhs, {begin_t: begin_t, items: items, end_t: end_t}
    super
  end

  def multi_assign(lhs, eql_t, rhs)
    emit_signal :multi_assign, {lhs: lhs, eql_t: eql_t, rhs: rhs}
    super
  end

  #
  # Class and module definition
  #

  def def_class(class_t, name,
                lt_t, superclass,
                body, end_t)
    emit_signal :def_class, {class_t: class_t, name: name, lt_t: lt_t, superclass: superclass, body: body, end_t: end_t}
    super
  end

  def def_sclass(class_t, lshft_t, expr,
                 body, end_t)
    emit_signal :def_sclass, {class_t: class_t, lshft_t: lshft_t, expr: expr, body: body, end_t: end_t}
    super
  end

  def def_module(module_t, name,
                 body, end_t)
    emit_signal :def_module, {module_t: module_t, name: name, body: body, end_t: end_t}
    super
  end

  #
  # Method (un)definition
  #

  def def_method(def_t, name_t, args,
                 body, end_t)
    emit_signal :def_method, {def_t: def_t, name_t: name_t, args: args, body: body, end_t: end_t}
    super
  end

  def def_singleton(def_t, definee, dot_t,
                    name_t, args,
                    body, end_t)
    emit_signal :def_singleton, {def_t: def_t, definee: definee, dot_t: dot_t, name_t: name_t, args: args, body: body, end_t: end_t}
    super
  end

  def undef_method(undef_t, names)
    emit_signal :undef_method, {undef_t: undef_t, names: names}
    super
  end

  def alias(alias_t, to, from)
    emit_signal :alias, {alias_t: alias_t, to: to, from: from}
    super
  end

  #
  # Formal arguments
  #

  def args(begin_t, args, end_t, check_args=true)
    emit_signal :begin_t, {args: args, end_t: end_t, check_args: check_args}
    super
  end

  def arg(name_t)
    emit_signal :arg, {name_t: name_t}
    super
  end

  def optarg(name_t, eql_t, value)
    emit_signal :optarg, {name_t: name_t, eql_t: eql_t, value: value}
    super
  end

  def restarg(star_t, name_t=nil)
    emit_signal :restarg, {star_t: star_t, name_t: name_t}
    super
  end

  def kwarg(name_t)
    emit_signal :kwarg, {name_t: name_t}
    super
  end

  def kwoptarg(name_t, value)
    emit_signal :kwoptarg, {name_t: name_t, value: value}
    super
  end

  def kwrestarg(dstar_t, name_t=nil)
    emit_signal :kwrestarg, {dstar_t: dstar_t, name_t: name_t}
    super
  end

  def shadowarg(name_t)
    emit_signal :shadowarg, {name_t: name_t}
    super
  end

  def blockarg(amper_t, name_t)
    emit_signal :blockarg, {amper_t: amper_t, name_t: name_t}
    super
  end

  def procarg0(arg)
    emit_signal :procarg0, {arg: arg}
    super
  end

  # Ruby 1.8 block arguments

  def arg_expr(expr)
    super
  end

  def restarg_expr(star_t, expr=nil)
    emit_signal :restarg_expr, {start: start_t, expr: expr}
    super
  end

  def blockarg_expr(amper_t, expr)
    emit_signal :blockarg_expr, {amper_t: amper_t, expr: expr}
    super
  end

  # MacRuby Objective-C arguments

  def objc_kwarg(kwname_t, assoc_t, name_t)
    emit_signal :objc_kwarg, {kwname_t: kwname_t, assoc_t: assoc_t, name_t: name_t}
    super
  end

  def objc_restarg(star_t, name=nil)
    emit_signal :objc_restarg, {start_t: star_t, name: name}
    super
  end

  #
  # Method calls
  #

  def call_type_for_dot(dot_t)
    emit_signal :call_type_for_dot, {dot_t: dot_t}
    super
  end

  def call_method(receiver, dot_t, selector_t,
                  lparen_t=nil, args=[], rparen_t=nil)
    emit_signal :call_method, {receiver: receiver, dot_t: dot_t, selector_t: selector_t, lparen_t: lparen_t, args: args, rparen_t: rparen_t}
    super
  end

  def call_lambda(lambda_t)
    emit_signal :call_lambda, {lambda_t: lambda_t}
    super
  end

  def block(method_call, begin_t, args, body, end_t)
    emit_signal :block, {method_call: method_call, begin_t: begin_t, args: args, end_t: end_t}
    super
  end

  def block_pass(amper_t, arg)
    emit_signal :block_pass, {amper_t: amper_t, arg: arg}
    super
  end

  def objc_varargs(pair, rest_of_varargs)
    emit_signal :objc_varargs {pair: pair, rest_of_varargs: rest_of_varargs}
    super
  end

  def attr_asgn(receiver, dot_t, selector_t)
    emit_signal :attr_asgn, {receiver: receiver, dot_t: dot_t, selector_t: selector_t}
    super
  end

  def index(receiver, lbrack_t, indexes, rbrack_t)
    emit_signal :index, {receiver: receiver, lbrack_t: lbrack_t, indexes: indexes, rbrack_t: rbrack_t}
    super
  end

  def index_asgn(receiver, lbrack_t, indexes, rbrack_t)
    emit_signal :index_asgn, {receiver: receiver, lbrack_t: lbrack_t, indexes: indexes, rbrack_t: rbrack_t}
    super
  end

  def binary_op(receiver, operator_t, arg)
    emit_signal :binary_op, {receiver: receiver, operator_t: operator_t, arg: arg}
    super
  end

  def match_op(receiver, match_t, arg)
    emit_signal :match_op, {receiver: receiver, match_t: match_t, arg: arg}
    super
  end

  def unary_op(op_t, receiver)
    emit_signal :unary_op, {op_t: op_t, receiver: receiver}
    super
  end

  def not_op(not_t, begin_t=nil, receiver=nil, end_t=nil)
    emit_signal :not_op, {not_t: not_t, begin_t: begin_t, receiver: receiver, end_t: end_t}
    super
  end

  #
  # Control flow
  #

  # Logical operations: and, or

  def logical_op(type, lhs, op_t, rhs)
    emit_signal :logical_op, {type: type, lhs: lhs, op_t: op_t, rhs: rhs}
    super
  end

  # Conditionals

  def condition(cond_t, cond, then_t,
                if_true, else_t, if_false, end_t)
    emit_signal :condition, {cond_t: cond_t, cond: cond, then_t: then_t, if_true: if_true, else_t: else_t if_false: if_false, end_t: end_t}
    super
  end

  def condition_mod(if_true, if_false, cond_t, cond)
    emit_signal :condition_mod, {if_true: if_true, if_false: if_false, cond_t: cond_t, cond: cond}
    super
  end

  def ternary(cond, question_t, if_true, colon_t, if_false)
    emit_signal :ternary, {cond: cond, question_t: question_t, if_true, colon_t: colon_t, if_false}
    super
  end

  # Case matching

  def when(when_t, patterns, then_t, body)
    emit_signal :when, {when_t: when_t, patterns: patterns, then_t: then_t, body: body}
    super
  end

  def case(case_t, expr, when_bodies, else_t, else_body, end_t)
    emit_signal :case, {case_t: case_t, expr: expr, when_bodies: when_bodies, else_t: else_t, else_body: else_body, end_t: end_t}
    super
  end

  # Loops

  def loop(type, keyword_t, cond, do_t, body, end_t)
    emit_signal :loop, {type: type, keyword_t: keyword_t, cond: cond, do_t: do_t, body: body, end_t: end_t}
    super
  end

  def loop_mod(type, body, keyword_t, cond)
    emit_signal :loop_mod, {type: type, body: body, keyword_t: keyword_t, cond: cond}
    super
  end

  def for(for_t, iterator, in_t, iteratee,
          do_t, body, end_t)
    emit_signal :for, {for_t: for_t, iterator: iterator, in_t: in_t, iteratee: iteratee, do_t: do_t, body: body, end_t: end_t}
    super
  end

  # Keywords

  def keyword_cmd(type, keyword_t, lparen_t=nil, args=[], rparen_t=nil)
    emit_signal :keyword_cmd, {type: type, keyword_t: keyword_t, lparen_t: lparen_t, args: args, rparen_t: rparen_t}
    super
  end

  # BEGIN, END

  def preexe(preexe_t, lbrace_t, compstmt, rbrace_t)
    emit_signal :preexe_t, {preexe_t: preexe_t, lbrace_t: lbrace_t, compstmt: compstmt, rbrace_t: rbrace_t}
    super
  end

  def postexe(postexe_t, lbrace_t, compstmt, rbrace_t)
    emit_signal :postexe, {postexe_t: postexe_t, lbrace_t: lbrace_t, compstmt: compstmt, rbrace_t: rbrace_t}
    super
  end

  # Exception handling

  def rescue_body(rescue_t,
                  exc_list, assoc_t, exc_var,
                  then_t, compound_stmt)
    emit_signal :rescue_body, {rescue_t: rescue_t, exc_list: exc_list, assoc_t: assoc_t, exc_var: exc_var, then_t: then_t, compound_stmt: compound_stmt}
    super
  end

  def begin_body(compound_stmt, rescue_bodies=[],
                 else_t=nil,    else_=nil,
                 ensure_t=nil,  ensure_=nil)
    emit_signal :begin_body, {compound_stmt: compound_stmt, rescue_bodies: rescue_bodies, else_t: else_t, else_: else_, ensure_t: ensure_t, ensure_: ensure_}
    super
  end

  #
  # Expression grouping
  #

  def compstmt(statements)
    emit_signal :compstmt, {statements: statements}
    super
  end

  def begin(begin_t, body, end_t)
    emit_signal :begin, {begin_t: begin_t, body: body, end_t: end_t}
    super
  end

  def begin_keyword(begin_t, body, end_t)
    emit_signal :begin_keyword, {begin_t: begin_t, body: body, end_t: end_t}
    super
  end
end