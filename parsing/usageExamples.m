%% MATLAB Parse Trees
%
% This prototype is intented to explore a user facing interface to code
% analysis that is approachable by casual users.
%
% A "regular" abstract syntax tree uses the same node structure for every
% node, using generic properties of nodes like "left", "right", and "next"
% as mtree does. While the regular form of these trees makes traversing 
% them simpler, They are very difficult to comprehend because 
% familiar language constructs like "function call" or "assignment
% statement" are mapped to idiosyncratic and unhelpfully named structures
% in the tree.
%
% In this prototype, I have created a class for each kind of language
% construct. The name of each class and the names of each classes
% properties are designed to make sense to users. For example, the node that describes a
% function definition is a:
%
%  FunctionDefinition with properties:
% 
%                name: [1x1 Literal]
%              inputs: [1x1 CommaSeperatedList]
%             outputs: [1x1 CommaSeperatedList]
%                body: [1x1 StatementBlock]
%
% and each of its properties is itself an object with a meaningful type and 
% properties. I'm hoping that users of this system can create, explore, and
% modify these trees without much difficulty, because the names and
% structures they see are in the language of the syntactic
% constructs they are familiar with.
%
% To allow code to automatically traverse these "irregular" trees, each
% node has a "children" method that returns a cell array of strings that
% identifies the subset of the nodes porperties that are ParseTreeNodes.
% To traverse the tree, a program must ask a node for its children and then
% iterate ofer them. The find method of the ParseTreeNode class is an
% example of this.
%
% In addition to this data structure, I've added a few sample analysis
% routines to show how these trees might be used. These routines are "find"
% and a family of "replace" operations, and a "char" method that reproduces
% MATLAB code.

%% First, we parse some code to get a parse tree.
tree =  parseString('a = 2 + 3.4;');

%% The show method will display the parse tree as a horizontal tree so we can examine it:
show(tree);

%%
% Indented below each class name are its properties, recursivly displayed.
% The root of this tree is an AssignmentStatement. AssignmentStatements
% have two properties: "assignedTo" and "assignedFrom". This
% AssignmentStatements assignedFrom property contains a node of type
% BinaryOperator, which in turn has three properties: "operator", "left",
% and "right". The AssignmentStatements assignedTo property contains a
% Literal. Literals are so common that they display differently from
% everyone else. They simple display their string (in this case "a") and
% their type, in parenthesis (ID). Any time you see (ID), (INT), or
% (DOUBLE), you're looking at a literal.

%% Lets try something more realistic:
tree = parseFile('invhilb');
% and examine that:
show(tree);

%% The char method of a tree recreates the equavalent MATLAB code, formatted in a "standard" way.
% Any formatting (whitespace) in the original code is lost.
char(tree)
%%
% You may find it instructive to compare the tree above to the code below.

%% Nodes of the parse tree are MCOS objects subclassing ParseTreeNode
% You can examine a parse tree by looking at the names and properties of its nodes.
% You should be able to understand the structure of each node type by 
% examining its name and properties.
% The root node in a parse of invhilb is a function definition.
tree

%% What is the name of this function?
tree.name


%% There are many subclasses of ParseTreeNode
dir ParseTree/*.m
% One for each syntactic construct in the MATLAB language.

%% Searching a parse tree
% The find method takes a class name to find all of the nodes of that
% class.

% Here, we search for all the assignment statements in invhilb.
matches = tree.find('AssignmentStatement')

% lets list the nodes we found.
for i = 1:length(matches)
    % char on any node produces the code for that node and its descendants.
    fprintf('Assignment %d: %s\n',i, char(matches{i}));
end

% Here's what one of those assignment statements contains
codeForOne = char(matches{4})
treeForOne = matches{4}


%% The find command also accepts a function handle to find more specific nodes
% The function must take a node as an input and return true if the node
% matches its criteria.

% This one matches var = functionCall(stuff)
test = @(node)(...
    isa(node,'AssignmentStatement')...
    && isa(node.assignedTo,'Literal')...
    && isa(node.assignedFrom,'FunctionCall'));

%%
% The function is evaluated at each node in the tree. Nodes for which the
% function returns true are gathered in the result.
matches = tree.find(test)

for i = 1:length(matches)
    fprintf('%s\n',char(matches{i}));
end

%% Renaming a variable
% Here we find all the nodes that are the literal 'p' and replace the
% string value in each literal with a new string, 'thisLittlePiggy'.
old = 'p';
new = 'thisLittlePiggy';

% Find literals whos string is 'p',
test = @(node)(isa(node,'Literal') && strcmp(node.string,old));
matches = tree.find(test);

% change them,
for i = 1:length(matches)
    % The name of a literal is stored in its string property.
    matches{i}.string = new;
end

% and display the changed code.
char(tree)

%% Replace one node with another
parseTree = parseString('a = b + c * d + e;');

% Find that multiplication
test = @(node)(isa(node,'BinaryOperator') && strcmp(node.operator,'MUL'));
f = parseTree.find(test); % always returns a cell array
multNode = f{1}

% Create a replacement
newNode = BinaryOperator('DIV',multNode.left,multNode.right)

% The replaceWith method will replace one node with another.
multNode.replaceWith(newNode);

char(parseTree)

%% Insert a statement before another statement
parseTree = parseString('a=1;b=2;d=3;')

% since I know parseTree is a StatementBlock in this case...
d = parseTree.statements{1}

newStatement = parseString('% This was inserted!')

parseTree.insertBefore(d,newStatement)
% p.insertAfter(old,new),p.replace(old,new), and p.remove(old) all work similarly.

char(parseTree)
 
%% Replace function callsites with inline expanded code
% the trick here is to replace the functions formal parameters with the
% callsites actual parameters. The real work is done by a class called
% "ExpandedFunctionCall", a new type of node that doesn't occur in MATLAB
% code!
%
% Here is the original code

tree = parseFile('testScript');
char(tree)


%% That code calls testFunction
type testFunction

%% Replace the call to testFunction with inline code.
calls = tree.find('FunctionCall');
call = calls{1};
expandedCall = ExpandedFunctionCall(call);
call.parent.replaceWith(expandedCall)

%% here is the new code with function expanded in line.
char(tree)

%% The end
% This code is available in my public directory: \\mathworks\Public\Joe_Hicklin\language
% Feel free to play with it as you like.
% If you have any questions, comments, or suggestions, let me know!
% joe@mathworks.com
