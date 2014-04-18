function expressionDisplay
    % this is a sample usage that incrementally displays the evaluation of
    % a complex expression, one change at a time to help debuggung.
    
    % if the expression has variables in it, they must come from some
    % "workspace"
    workspace.A = 12;
    workspace.X3 = 51.4;
    expression = 'a = 1 + X3 * cos(3) - 4 + min(3, 5) / 4 < A - 4 * 2 ^ 5;';
    
    p = parseString(expression);
    
    leaves = p.find(@isLeaf);
    fprintf('Initial expression:\n%s\n\n',char(p));
    while ~isempty(leaves)
        for i = 1:length(leaves)
            oldNode = leaves{i};
            oldCode = char(oldNode);
            
            % create the replacement node
            value = evalWRT(oldCode,workspace);
            newNode = Literal('DOUBLE',sprintf('%g',value));
            newCode = char(newNode);
            
            % calculate padding to make the two displays below line up
            expansion = length(newCode) - length(oldCode);
            if expansion > 0
                p1 = expansion;
                p2 = 0;
            else
                p1 = 0;
                p2 = -expansion;
            end
            
            % Display the expression while hiliting the operation to be
            % evaluated.
            h = Hilite(oldNode,p1);
            oldNode.replaceWith(h);
            fprintf('%s\n',char(p));
            
            % Display the expression while hiliting the result of that
            % evaluation
            h2 = Hilite(newNode,p2);
            h.replaceWith(h2);
            fprintf('%s\n\n',char(p));
            
            % remove the hiliting
            h2.replaceWith(newNode);
        end
        leaves = p.find(@isLeaf);
    end
    fprintf('%s\n',char(p));
end

function tf = isLeaf(node)
    if (isa(node,'BinaryOperator') || isa(node,'Compare')) && isa(node.left,'Literal') && isa(node.right,'Literal');
        tf = true;
        return
    end
    
    if isa(node,'FunctionCall')
        inputs = node.inputs.contents;
        tf = true;
        for i = 1:length(inputs)
            if ~isa(inputs{i},'Literal')
                tf = false;
                break;
            end
        end
        return
    end
    
    tf = false;
    return
end

function value = evalWRT(stringForEvalWRT,workspace)
    %evaluate string With Respect To the given workspace
    for indexForEvalWRT = fields(workspace)'
        eval(sprintf('%s = workspace.%s;',indexForEvalWRT{1},indexForEvalWRT{1}));
    end
    clear indexForEvalWRT
    clear workspace
    value = eval(stringForEvalWRT);
end