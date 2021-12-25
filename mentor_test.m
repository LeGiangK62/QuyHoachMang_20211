w_mentor = 3;
R = 0.3;
C = 2;
numNode = 17;
location_Mat = [8 9;    %1
                1 8;    %2
                4 8;    %3
                9 8;    %4
                6 7;    %5
                2 6;    %6
                4 5;    %7
                6 4;    %8
                9 4;    %9
                0 3;    %10
                2 3;    %11
                4 2;    %12
                8 3;    %13
                1 1;    %14
                6 1;    %15
                3 0;    %16
                9 0    %17                
];

weight_Mat = [1; 1; 1; 1; 8; 9; 1; 1; 1; 1; 1; 7; 1; 1; 1; 1; 5];

figure();
hold on;
axis equal;
grid on;
for i = 1:numNode
    disp_node(i, location_Mat, 0)
end

hold off;

status_Mat = mentor(w_mentor, R, C, weight_Mat, location_Mat);

figure();
hold on;
axis equal;
grid on;
for i = 1:numNode
    disp_node(i, location_Mat, status_Mat(i) == -1)
    if status_Mat(i) ~= -1
        disp_line(i, status_Mat(i), location_Mat);
    end
end

hold off;
