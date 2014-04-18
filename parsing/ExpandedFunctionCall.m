classdef ExpandedFunctionCall < ParseTreeNode
    % A function callsite expanded to contain the code of the called
    % function, with the formal parameters replaces by the actual
    % parameters.
    
    properties
        name
        body
        oldCall
    end
    
    methods
        
        function this = ExpandedFunctionCall(functionCallNode)
            this.name = functionCallNode.name.string;
            this.oldCall = char(functionCallNode.parent);
            functionDefinition = parseFile(this.name);
            this.body = functionDefinition.body;
            
            % rename inputs
            actualParameters = functionCallNode.inputs.contents;
            formalParameters = functionDefinition.inputs.contents;
            for i = 1:length(actualParameters)
                formalParameter = formalParameters{i}.string;
                actualParameter = actualParameters{i}.string;
                test = @(node)(isa(node,'Literal') && strcmp(node.string,formalParameter));
                matches = functionDefinition.find(test);
                for j = 1:length(matches)
                    matches{j}.string = actualParameter;
                end
            end
            
            % rename outputs
            assignmentStatement = functionCallNode.parent;
            outputs = assignmentStatement.assignedTo;
            % could ba a literal or a comma separated list.
            if isa(outputs,'Literal')
                actualOutputs = {outputs};
            else
                actualOutputs = outputs.contents;
            end
            
            formalOutputs = functionDefinition.outputs.contents;
            for i = 1:length(actualOutputs)
                formalOutput = formalOutputs{i}.string;
                actualOutput = actualOutputs{i}.string;
                test = @(node)(isa(node,'Literal') && strcmp(node.string,formalOutput));
                matches = functionDefinition.find(test);
                for j = 1:length(matches)
                    matches{j}.string = actualOutput;
                end
            end
            
            
            %% clear local variables
            localVariables = {Literal('ID','foo')};
            clear = Command(Literal('ID','clear'),CommaSeperatedList(localVariables));
            this.body.insertAt(1 + length(this.body.statements),clear);
        end
        
        function matlabCode(this,code)
            code.insert(sprintf('%% %s',this.oldCall));
            this.body.matlabCode(code)
            code.newline
            code.insert(sprintf('%% end of %s',this.name));
        end
        
        function nodes = children(this)
            nodes = {'name','body'};
        end
    end
    
end

