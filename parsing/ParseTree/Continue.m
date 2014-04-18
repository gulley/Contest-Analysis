classdef Continue < ParseTreeNode
    
    properties
     end
    
    methods
      
        function matlabCode(this,code)
            code.insert('continue')
        end
        
    end
    
end

