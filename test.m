clear
raw_data = load('karate_club_edges.txt');
shape = size(raw_data);
lines = shape(1);
nodeNum = max(max(raw_data(:,1)),max(raw_data(:,2)));
AM = zeros(nodeNum,nodeNum);
for i = 1:lines
    x = raw_data(i,1);
    y = raw_data(i,2);
    AM(x,y) = AM(x,y)+1;
    AM(y,x) = AM(y,x)+1;
end
[flow,p,telep] = RandomWalk(AM);
nodeclass = [1,1,1,1,1,1,1,1,1,2,1,1,1,1,2,2,1,1,2,1,2,1,2,2,2,2,2,2,2,2,2,2,2,2];
[ LM, withinCL, betweenCL ] = MapEquation(nodeclass, flow, p, telep);
[hdakda] = greedy(flow,p,telep);