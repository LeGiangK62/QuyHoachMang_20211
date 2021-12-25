link_cost = [   0   2   Inf 12  Inf Inf Inf 3;
                2   0   1   10  Inf Inf Inf Inf;
                Inf 1   0   8   2   Inf Inf Inf;
                12  10  8   0   9   5   6   7;
                Inf Inf 2   9   0   2   Inf Inf;
                Inf Inf Inf 5   2   0   1   Inf;
                Inf Inf Inf 6   Inf 1   0   2;
                3   Inf Inf 7   Inf Inf 2   0];
w_ew = 4;
weight_Mat = [1;2;3;0;1;2;1;1];
numNode = 8;
status_Mat = [4,4,4,-1,4,4,4,4];
x = 2;
y = 1;
location_Mat = [y+x     y+2*x; %A
                y       y+x; %B
                y       y; %C
                y+x     y+x; %D
                y+x     y; %E
                y+2*x   y; %F
                y+2*x   y+x; %G
                y+2*x   y+2*x %H
                ];
figure();
hold on;
axis equal;
grid on;
for i = 1:numNode
    disp_node(i, location_Mat, status_Mat(i) == -1)
end

hold off;
%%

% EW_test = esau_williams(w_ew, link_cost, status_Mat, weight_Mat, 0);
% plot_all(0, location_Mat, status_Mat, EW_test);

K_test = kruskal(w_ew, link_cost, status_Mat, weight_Mat);
plot_all(0, location_Mat, status_Mat, K_test);



%% Nested function
