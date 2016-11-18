function[communities] = greedy(flow, p, telep)

nodeclass = [1:34];
flag = 0;
v = cell(1,length(nodeclass));
for i = 1:length(nodeclass)
    v{i} = nodeclass(i);
end
[Min,a,b] = MapEquation(nodeclass, flow, p, telep);
while flag == 0
    C = nchoosek(v,2);
    c = nchoosek([1:length(v)],2);
    min_list = [];
    for i = 1:length(C)
        cluster_num = [1:length(v)];
        v_tmp = cell(1,1);
        v_tmp{1} = [C{i,1},C{i,2}];
        cluster_num(c(i,2)) = [];
        cluster_num(c(i,1)) = [];
        for j = 1: length(cluster_num)
            v_tmp{length(v_tmp)+1} = v{cluster_num(j)};
        end
        class_try = nodeclass;
        for j = 1:length(v_tmp)
            hahah = v_tmp{j};
            class_try(hahah) = j;
            
        end
        [Min,a,b] = MapEquation(class_try, flow, p, telep);
        min_list(length(min_list)+1) = Min;
    end
    [M,index] = min(min_list);
    if M <= Min
        first = c(index,1);
        second = c(index,2);
        v{first} = [v{first},v{second}];
        v(second) = [];
        Min = M;
    v{1}
    v{2}
    Min
    else
        flag = 1;
    end
end
communities = 0;

        
    
