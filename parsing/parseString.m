function node = parseString( inputString )
    % This file understands the structure of the mtreemex table and the
    % construction syntax of allof the parse tree node types.
    
    parseLibrary = fullfile(pwd,'ParseTree');
    if isempty(strfind(path,parseLibrary))
        addpath(parseLibrary);
    end
    
    global nodeNames
    if(isempty(nodeNames))
        nodeNames = mtreemex;
    end
    
    % Table column meanings
    % 1 = node type
    % 2 = left child
    % 3 = right child
    % 4 = next
    % 8 = index into strings
    % 11 = start index in inputString
    % 12 = end index in inputString
    
    % chew on a row so comments don't need to be transposed
    if iscolumn(inputString)
        inputString = inputString';
    end
    
    [table,~,strings] = mtreemex(inputString,'-comments','-whitespace');
    
    list = createList(1,table,strings,inputString);
    if 1 == length(list)
        node = list{1};
    else
        node = StatementBlock(list);
    end
    
end

function node = createTree(index,table,strings,inputString)
    global nodeNames
    
    nodeType = nodeNames{table(index,1)};
    switch nodeType
        case {'AND','ANDAND','OR','OROR','DIV','MUL','PLUS','MINUS','EXP','DOTMUL','DOTEXP'}
            leftOperand  = createLeftTree(index,table,strings,inputString);
            rightOperand = createRightTree(index,table,strings,inputString);
            node = BinaryOperator(nodeType,leftOperand,rightOperand);
        case 'ANON'
            ids  = CommaSeperatedList(createList(table(index,2),table,strings,inputString));
            expression = createRightTree(index,table,strings,inputString);
            node = AnonymousFunctionDefinition(ids,expression);
        case 'ANONID'
            text = inputString(table(index,11): table(index,12))';
            node = Literal('ID',text);
        case 'AT'
            name = createLeftTree(index,table,strings,inputString);
            node = At(name);
        case 'ATTR'
            attributeName = createLeftTree(index,table,strings,inputString);
            attributeValue = createRightTree(index,table,strings,inputString);
            node = Attribute(attributeName,attributeValue);
        case 'ATTRIBUTES'
            node = CommaSeperatedList(createList(table(index,2),table,strings,inputString));
        case 'BLKCOM'
            text = inputString(table(index,11): table(index,12))';
            node = BlockComment(text);
        case 'BREAK'
            node = Break;
        case 'CALL'
            name = createLeftTree(index,table,strings,inputString);
            inputs = CommaSeperatedList(createList(table(index,3),table,strings,inputString));
            node = FunctionCall(name,inputs);
        case {'CASE','OTHERWISE'}
            name = createLeftTree(index,table,strings,inputString);
            body = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = Case(name,body);
        case 'CATCH'
            node = Junk('catch',[]);
        case 'CELL'
            var  = createLeftTree(index,table,strings,inputString);
            contents = CommaSeperatedList(createList(table(index,3),table,strings,inputString));
            node = CellArray(var, contents);
        case 'CLASSDEF'
            cexpr = table(index,2);
            classNames = createRightTree(cexpr,table,strings,inputString);
            blocks = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = ClassDef(classNames,blocks);
        case 'COLON'
            leftNode  = createLeftTree(index,table,strings,inputString);
            rightNode = createRightTree(index,table,strings,inputString);
            node = ColonOperator(leftNode,rightNode);
        case 'COMMENT'
            text = inputString(table(index,11): table(index,12));
            node = Comment(text);
        case 'CONTINUE'
            node = Continue;
        case 'DCALL'
            name = createLeftTree(index,table,strings,inputString);
            args = CommaSeperatedList(createList(table(index,3),table,strings,inputString));
            node = Command(name,args);
        case 'DOT'
            leftNode  = createLeftTree(index,table,strings,inputString);
            rightNode = createRightTree(index,table,strings,inputString);
            node = Dot(leftNode,rightNode);
        case 'DOTLP'
            name  = createLeftTree(index,table,strings,inputString);
            contents = CommaSeperatedList(createList(table(index,3),table,strings,inputString));
            node = DotLP(name,contents);
        case {'EXPR','PARENS'}
            % expr is a tofu node. We simply move on to its only child node
            node = createLeftTree(index,table,strings,inputString);
        case 'EQUALS'
            leftHandSide  = createLeftTree(index,table,strings,inputString);
            rightHandSide = createRightTree(index,table,strings,inputString);
            node = AssignmentStatement(leftHandSide,rightHandSide);
        case 'FIELD'
            node = Field(Literal('FIELD',strings{table(index,8)}));
        case 'FOR'
            loop = table(index,2);
            loopVar = createLeftTree(loop,table,strings,inputString);
            loopRange = createRightTree(loop,table,strings,inputString);
            loopBody = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = ForLoop(loopVar,loopRange,loopBody);
        case 'FUNCTION'
            headerEtc = table(index,2);
            outputs  = CommaSeperatedList(createList(table(headerEtc,2),table,strings,inputString));
            inputEtc = table(headerEtc,3);
            name   = createLeftTree(inputEtc,table,strings,inputString);
            inputs = CommaSeperatedList(createList(table(inputEtc,3),table,strings,inputString));
            body    = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = FunctionDefinition(name,outputs,inputs,body);
        case 'GLOBAL'
            varNames = CommaSeperatedList(createList(table(index,2),table,strings,inputString));
            node = Global(varNames);
        case 'IF'
            ifBlocks = StatementBlock(createList(table(index,2),table,strings,inputString));
            node = IfStatement(ifBlocks);
        case {'IFHEAD','ELSE','ELSEIF'}
            condition  = createLeftTree(index,table,strings,inputString);
            body = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = IfBlock(condition,body);
        case {'INT','ID','STRING','DOUBLE'}
            node = Literal(nodeType,strings{table(index,8)});
        case {'LB','LC','LP'}
            contents  = CommaSeperatedList(createList(table(index,2),table,strings,inputString));
            node = Catenation(nodeType,contents);
        case {'LT','GT','LE','GE','EQ','NE'}
            leftOperand  = createLeftTree(index,table,strings,inputString);
            rightOperand = createRightTree(index,table,strings,inputString);
            node = Compare(nodeType,leftOperand,rightOperand);
        case 'METHODS'
            attributes = createLeftTree(index,table,strings,inputString);
            contents = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = Methods(attributes,contents);
        case 'NOT'
            if(0 == table(index,2));
                node = Literal('NOT','~');
            else
                operand  = createLeftTree(index,table,strings,inputString);
                node = UnaryOperator(nodeType,operand);
            end
        case 'PERSISTENT'
            varNames = CommaSeperatedList(createList(table(index,2),table,strings,inputString));
            node = Persistent(varNames);
        case 'PRINT'
            statement  = createLeftTree(index,table,strings,inputString);
            node = AutoPrint(statement);
        case 'PROPERTIES'
            attributes = createLeftTree(index,table,strings,inputString);
            contents = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = Properties(attributes,contents);
        case 'PROTO'
            headerEtc = table(index,2);
            outputs  = CommaSeperatedList(createList(table(headerEtc,2),table,strings,inputString));
            inputEtc = table(headerEtc,3);
            name   = createLeftTree(inputEtc,table,strings,inputString);
            inputs = CommaSeperatedList(createList(table(inputEtc,3),table,strings,inputString));
            body    = [];
            node = FunctionDefinition(name,outputs,inputs,body);
        case 'RETURN'
            node = Return;
        case 'ROW'
            node  = CommaSeperatedList(createList(table(index,2),table,strings,inputString));
        case 'SUBSCR'
            varName    = createLeftTree(index,table,strings,inputString);
            subscripts = CommaSeperatedList(createList(table(index,3),table,strings,inputString));
            node = Subscript(varName,subscripts);
        case 'SWITCH'
            switchVar = createLeftTree(index,table,strings,inputString);
            cases = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = Switch(switchVar,cases);
        case 'TRANS'
            operand  = createLeftTree(index,table,strings,inputString);
            node = Trans(operand);
        case 'TRY'
            tryBlock  = StatementBlock(createList(table(index,2),table,strings,inputString));
            catchNode = table(index,3);
            errorName  = createLeftTree(catchNode,table,strings,inputString);
            catchBlock = StatementBlock(createList(table(catchNode,3),table,strings,inputString));
            node = Try(tryBlock,errorName,catchBlock);
        case 'UMINUS'
            operand  = createLeftTree(index,table,strings,inputString);
            node = UnaryOperator(nodeType,operand);
        case 'WHILE'
            condition = createLeftTree(index,table,strings,inputString);
            loopBody = StatementBlock(createList(table(index,3),table,strings,inputString));
            node = While(condition,loopBody);
        case 'ERR'
            % fprintf('A syntax error was found while parsing the string.\n');
            node = Junk(nodeType,'Syntax Error');
        otherwise
            first = table(index,11);
            last = table(index,12);
            if(first > 0)
                code = inputString(first: last);
            else
                code = 'code unknown';
            end
            node = Junk(nodeType,code);
            fprintf('parseString has encountered a type of node it does not understand.\n');
            fprintf('Unhandled Node Type: %s\n',nodeType);
            fprintf('Here is (some of) the code where the problem occurred:\n');
            fprintf('%s\n',code(1:min(200,end)));
    end
end

function leftNode = createLeftTree(index,table,strings,inputString)
    if(table(index,2) == 0)
        leftNode = [];
    else
        leftNode = createTree(table(index,2),table,strings,inputString);
    end
end

function rightNode = createRightTree(index,table,strings,inputString)
    if(table(index,3) == 0)
        rightNode = [];
    else
        rightNode = createTree(table(index,3),table,strings,inputString);
    end
end

function nodes = createList(index,table,strings,inputString)
    nodes = {};
    while index ~= 0
        nodes{end+1} = createTree(index,table,strings,inputString);
        index = table(index,4);
    end
end