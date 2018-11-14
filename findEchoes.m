function echoes = findEchoes(seq,om_store)
% Given om_store output and seq information
% We find the proper echos

% Criteria: 
% (a) The F(0) component must be non-zero (>5*eps)
% (b) There must not be a RF pulse at the same time
% (c) If S & E happens at the same time point,
%     use the second value. (after both effects happen)
% S: gradient shift effect 
% E: T1&T2 relaxation effect
echoes = [];
timing = seq.time;
%rftimes = timing(strcmp(seq.events,'rf'));
for v = 1:length(om_store)
    if abs(om_store{v}(1,1)) > 5*eps %&& sum(rftimes == timing(v))==0 
        newecho = [timing(v),abs(om_store{v}(1,1))];
        if ~isempty(echoes) && echoes(end,1) == timing(v)
            echoes = [echoes(1:end-1,:);newecho];
        else 
            echoes = [echoes;newecho];
        end
        
    end
end


echoes = unique(echoes,'rows');

end

