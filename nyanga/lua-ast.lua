local build = require('nyanga.syntax').build

local AST = { }

local function func_decl(id, body, params, vararg, locald, line)
    return build("FunctionDeclaration", {
        id         = id,
        body       = body,
        params     = params,
        vararg     = vararg,
        locald     = locald,
        line       = line
    })
end

local function func_expr(body, params, vararg, line)
    return build("FunctionExpression", { body = body, params = params, vararg = vararg, line = line })
end

function AST.expr_function(ast, args, body, proto, line)
   return func_expr(body, args, proto.varargs, line)
end

function AST.local_function_decl(ast, name, args, body, proto, line)
    local id = ast:identifier(name)
    return func_decl(id, body, args, proto.varargs, true, line)
end

function AST.function_decl(ast, path, args, body, proto, line)
    local fn = func_expr(body, args, proto.varargs, line)
    return build("AssignmentExpression", { left = { path }, right = { fn }, line = line })
end

function AST.chunk(ast, body, line)
    return build("Chunk", { body = body, line = line })
end

function AST.block_stmt(ast, body, line)
    return build("BlockStatement", { body = body, line = line })
end

function AST.local_decl(ast, vlist, exps, line)
    local ids = {}
    for k = 1, #vlist do ids[k] = ast:identifier(vlist[k]) end
    return build("LocalDeclaration", { names = ids, expressions = exps, line = line })
end

function AST.assignment_expr(ast, vars, exps, line)
    return build("AssignmentExpression", { left = vars, right = exps, line = line })
end

function AST.expr_index(ast, v, index, line)
    return build("MemberExpression", { object = v, property = index, computed = true, line = line })
end

function AST.expr_property(ast, v, prop, line)
    local index = ast:identifier(prop)
    return build("MemberExpression", { object = v, property = index, computed = false, line = line })
end

function AST.literal(ast, val)
    return build("Literal", { value = val })
end

function AST.expr_vararg(ast)
    return build("Vararg", { })
end

function AST.expr_table(ast, avals, hkeys, hvals, line)
    return build("Table", { array_entries = avals, hash_keys = hkeys, hash_values = hvals, line = line })
end

function AST.expr_unop(ast, op, v)
    return build("UnaryExpression", { operator = op, argument = v, line = line })
end

local function concat_append(ts, node)
    local n = #ts
    if node.kind == "ConcatenateExpression" then
        for k = 1, #node.terms do ts[n + k] = node.terms[k] end
    else
        ts[n + 1] = node
    end
end

function AST.expr_binop(ast, op, expa, expb)
    local binop_body = (op ~= '..' and { operator = op, left = expa, right = expb, line = line })
    if binop_body then
        if op == 'and' or op == 'or' then
            return build("LogicalExpression", binop_body)
        else
            return build("BinaryExpression", binop_body)
        end
    else
        local terms = { }
        concat_append(terms, expa)
        concat_append(terms, expb)
        return build("ConcatenateExpression", { terms = terms, line = expa.line })
    end
end

function AST.identifier(ast, s)
    return build("Identifier", { name = s, line = line })
end

function AST.expr_method_call(ast, v, key, args)
    local m = ast:identifier(key)
    return build("SendExpression", { receiver = v, method = m, arguments = args })
end

function AST.expr_function_call(ast, v, args)
    return build("CallExpression", { callee = v, arguments = args, line = line })
end

function AST.return_stmt(ast, exps, line)
    return build("ReturnStatement", { arguments = exps, line = line })
end

function AST.break_stmt(ast, line)
    return build("BreakStatement", { line = line })
end

function AST.label_stmt(ast, name, line)
    local label = ast:identifier(name)
    return build("LabelStatement", { label = label, line = line })
end

function AST.new_statement_expr(ast, expr, line)
    return build("ExpressionStatement", { expression = expr, line = line })
end

function AST.if_stmt(ast, tests, cons, else_branch, line)
    return build("IfStatement", { tests = tests, cons = cons, alternate = else_branch, line = line })
end

function AST.while_stmt(ast, test, body, line)
    return build("WhileStatement", { test = test, body = body, line = line })
end

function AST.repeat_stmt(ast, test, body, line)
    return build("RepeatStatement", { test = test, body = body, line = line })
end

function AST.for_stmt(ast, var, init, last, step, body, line)
    local for_init = build("ForInit", { id = var, value = init, line = line })
    return build("ForStatement", { init = for_init, last = last, step = step, body = body, line = line })
end

function AST.for_iter_stmt(ast, vars, exps, body, line)
    local init = build("ForNames", { names = vars, line = line })
    if #exps > 1 then error('NYI: iter with multiple expression list') end
    local iter = exps[1]
    return build("ForInStatement", { init = init, iter = iter, body = body, line = line })
end

local ASTClass = { __index = AST }

local function new_ast()
    return setmetatable({ }, ASTClass)
end

return {New = new_ast}