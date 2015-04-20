classdef nconetwork
    properties
    nd;
    f;
    adj=zeros(1969,1969);
    opinion=zeros(1969,1);
    end
    methods
        function obj=nconetwork(nodes,adja,opin,frc)
            obj.nd=nodes;
            obj.adj=adja;
            obj.opinion=opin;
            obj.f=frc;
            
        end
    end
end
    