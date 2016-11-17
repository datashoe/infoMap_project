%function [flow,p,teleportP] = RandomWalk(AM, recorded, link)
clear
AM = load('cattle.txt');
alpha = 0.15;
%W = AM';
nodeNum = length(AM);

win = sum(AM);
wout = sum(AM,2);
wall = sum(win);

pfortelep = ones(nodeNum,1)/nodeNum;

transMat = AM;
t = AM;

p = ones(nodeNum,1)/nodeNum;
for i = 1:nodeNum
    if wout(i) == 0
        transMat(i,:) = 1/nodeNum;
    else
        temp = transMat(i,:)';
        temp = temp./wout(i);
        transMat(i,:) = temp';
        t(i,:) = transMat(i,:);
    end
end

for i = 1:10000
    former = p;
    p = p'*transMat*(1-alpha);
    
    for j = 1:nodeNum
        p(j) = p(j)+alpha*pfortelep(j);
    end
    
    p = p'/sum(p);
    
    if sumabs( former - p ) < 1e-10
        fprintf('converged');
        break;
    end
end

pofstep = zeros(nodeNum);

for i = 1:nodeNum
    if wout(i) == 0
        pofstep(i,:) = pfortelep;
    else
        pofstep(i,:) = AM(i,:)/wout(i);
    end
end

%compute edge rate
edge_rate = zeros(nodeNum,nodeNum);
for i = 1:nodeNum
    for j = 1:nodeNum
        edge_rate(j,i) = edge_rate(j,i) + pofstep(j,i)*p(j);
    end
end
sumofedge = sum(sum(edge_rate));
edge_rate = edge_rate/sumofedge;

%flow
num = nnz(edge_rate);
flow = zeros(num,3);
count = 1;
fw = 0;
for i = 1:nodeNum
    for j = 1:nodeNum
        if edge_rate(j,i) ~= 0
            fw = edge_rate(j,i);
            flow(count,1) = j;
            flow(count,2) = i;
            flow(count,3) = fw;
            count = count+1;
        end
    end
end
count = count-1;
for i = 1:count
    flow(i,3) = flow(i,3)*(1-alpha);
end
    

