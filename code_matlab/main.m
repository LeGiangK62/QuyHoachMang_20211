% clear;
close all;
%% Simulation Parameters

map_size = 1000; % Plane: size x size
numNode = 100; % Number of nodes
R = 0.4; % Radius?
C = 20; % Link capacity
w_mentor = 2;  % Weigh - MENTOR
w_ew = 10; % Weigh max - Esau Williams

%% Topology Genarate
% [location_Mat, dist_Mat, weight_Mat] = init_topo(map_size, numNode);

plot_all(map_size, location_Mat, zeros(numNode,1), 0, 'Topo bai toan');

%% MENTOR
% [status_Mat] = mentor(w_mentor, 0.4, C, weight_Mat, location_Mat);
% % Status Matrix:    -1  - backbone
% %                   x   - access of backbone x
% %                   0   - uncatergorized
% % 
plot_all(map_size, location_Mat, status_Mat, 0, 'MENTOR');

    
%% Esau Williams
EW_link = esau_williams(w_ew, dist_Mat, status_Mat, weight_Mat, 0);
% plot_access(location_Mat, status_Mat, EW_link)
plot_all(map_size, location_Mat, status_Mat, EW_link, 'EW - no depth limit');
EW_cost = cost_link(dist_Mat, EW_link);

%% KRUSKAL
kruskal_link = kruskal(w_ew + 1, dist_Mat, status_Mat, weight_Mat);
% plot_access(location_Mat, status_Mat, kruskal_link)
plot_all(map_size, location_Mat, status_Mat, kruskal_link, 'Kruskal bien doi');
Kruskal_cost = cost_link(dist_Mat, kruskal_link);

%% Hieu chinh depth?
depth = 4;
EW_link_depth = esau_williams(w_ew, dist_Mat, status_Mat, weight_Mat, depth);
% plot_access(location_Mat, status_Mat, EW_link_depth)
plot_all(map_size, location_Mat, status_Mat, EW_link_depth, 'EW - DEPTH limited = 4');
EW_cost_depth = cost_link(dist_Mat, EW_link_depth);
