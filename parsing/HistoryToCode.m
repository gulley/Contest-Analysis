function  HistoryToCode()
    % Here is an example usage of the parse tree code that traverses your
    % sessions history buffer and extracts only the commands needed to
    % reproduce the final command in the history list.
    % It only works in simple cases, lots of exceptions are not handled:
    % ( load, clear, ans)
    
    % get your history
    history = com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;
    history =cellstr(char(history));
    
    % The expression we want to capture is the last one before the call to
    % this function.
    index = length(history) - 1;
    lastExpression = history{index};
    fprintf('creating code to produce %s\n',lastExpression);
    
    % what IDs does you expression depend on?
    tree = parseString(lastExpression);
    neededForInitialExpression = IDsNeeded(tree);
    
    % While we need more IDs resolved...
    while ~isempty(neededForInitialExpression)
        index = index - 1;
        
        if index == 0 % no more history?
            failed = false;
            for i = 1:length(neededForInitialExpression)
                id = neededForInitialExpression{i};
                if ~(exist(id,'builtin') || exist(id,'class') || exist(id,'file'))
                    fprintf('I cannot find "%s" in the history of this session!\n',id);
                    failed = true;
                end
            end
            if failed
                error('Histry To Code could not find a satisfactory history');
            else
                fprintf('That will do it!\n')
                return;
            end
        end
        
        previousExpression = history{index};
        try
            tree = parseString(previousExpression);
        catch
            % if it doesn't parse, skip it.
            continue
        end
        
        % This would be a reasonable place to check for a clear statement.
        % if we hit one, we can stop looking at prior statements.
        
        neededByThisExpression   = IDsNeeded(tree);
        producedByThisExpression = IDsDefined(tree);
        
        fulfilledByThisExpression = intersect(neededForInitialExpression,producedByThisExpression);
        neededForInitialExpression = setdiff(neededForInitialExpression,fulfilledByThisExpression);
        
        if ~isempty(fulfilledByThisExpression)
            fprintf('Needed: %s\n',char(previousExpression));
            neededForInitialExpression = union(neededForInitialExpression,neededByThisExpression);
        end
    end
    
end

function IDs = IDsNeeded(tree)
    % what ids are read by this tree?
    
    if isa(tree,'AutoPrint')
        tree = tree.statement;
    end
    
    if isa(tree,'AssignmentStatement')
        tree = tree.assignedFrom;
    end
    
    isID = @(node) isa(node,'Literal') && strcmp(node.type,'ID');
    literals = tree.find(isID);
    
    IDs = {};
    for i = 1:length(literals)
        IDs{end+1} = literals{i}.string;
    end
end

function IDs = IDsDefined(tree)
    % What IDs are defined by this tree?
    
    % we could look for load statements and then use the matfile object to
    % learn what variables are resolved by the load.
    
    assignments = tree.find('AssignmentStatement');
    
    IDs = {};
    for i = 1:length(assignments)
        statement = assignments{i};
        to = statement.assignedTo;
        if isa(to,'Literal')
            IDs{end+1} = to.string;
        end
    end
end