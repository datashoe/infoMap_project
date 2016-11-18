function [ LM, withinCL, betweenCL ] = MapEquation(nodeclass, flow, visitfreq, telep)
moduleset = cell(1,max(nodeclass));

for i = 1:length(nodeclass)
    moduleset{nodeclass(i)} = [moduleset{nodeclass(i)}, i];
end

alpha = 0.15;
num_modules = max(nodeclass);
%compute exit probability for each module
q_exit = zeros(1,num_modules);
for i = 1:length(flow)
    ent_module = nodeclass(flow(i,1));
    qit_module = nodeclass(flow(i,2));
    w = flow(i,3);
    if ent_module ~= qit_module
        q_exit(qit_module) = q_exit(qit_module) + w;
    end
end

%compute the movement within modules
withinCL = zeros(1,num_modules);
for i = 1:num_modules
    
    p_alpha = 0;
    module = moduleset{i};
    for j = 1:length(module)
        p_alpha = p_alpha + visitfreq(module(j));
    end
    % add teleportation
    fraction = (length(nodeclass)-length(module))/(length(nodeclass)-1);
    telep = alpha*fraction*p_alpha;
    q_exit(i) = q_exit(i) + telep;
    % compute entropy part
    p_i = q_exit(i) + p_alpha;
    H_pi = 0;
    for j = 1:length(module)
        entropy = (visitfreq(module(j))/p_i)*log2(visitfreq(module(j))/p_i);
        if visitfreq(module(j))/p_i ~= 0
            H_pi = H_pi - entropy;
        end
    end
    
    if q_exit(i)/p_i ~= 0
        entropy_exit = (q_exit(i)/p_i)*log2(q_exit(i)/p_i);
        H_pi = H_pi - entropy_exit;
    end
    
    withinCL(i) = withinCL(i)+ p_i*H_pi;
end  
% compute the movement between modules
q_exit_sum = sum(q_exit);
H_q = 0;
for i = 1:num_modules
    if q_exit(i)/q_exit_sum ~= 0
        H_q = H_q - (q_exit(i)/q_exit_sum)*log2(q_exit(i)/q_exit_sum);
    end
end
betweenCL = q_exit_sum*H_q;
LM = betweenCL + sum(withinCL);
    
        
    
    
    
    