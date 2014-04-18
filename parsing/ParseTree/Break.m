classdef Break < ParseTreeNode
    
    properties
     end
    
    methods
      
        function matlabCode(this,code)
            code.insert('break')
        end
        
    end
    
end

