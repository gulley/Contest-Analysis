function codeOut = codesplit(codeIn)
    %CODESPLIT Split the code into separate lines
    %    Split the code provided as a single string into a cell array of
    %    lines of code. The output code is divided into a cell array.
   
    if isempty(codeIn)
        codeOut = {};
    else
        codeOut = regexp(codeIn,'\r?\n','split');
    end
    
end