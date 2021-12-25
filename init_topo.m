function [location_Mat, dist_Mat, weight_Mat] = init_topo(map_size, numNode)
    % Init the problem topo, traffic and weight
%     global traffic_Mat %#ok<*REDEF>
%     global location_Mat
%     global weight_Mat
    
    traffic_Mat = zeros(numNode); %#ok<*NASGU>
    location_Mat = zeros(numNode,2);      %#ok<*PREALL>
    weight_Mat = zeros(numNode,1);

%     figure();
%     rectangle('Position',[0 0 size size])
%     hold on;
%     axis([-50 size+50 -50 size+50]);
%     axis equal;
%     for i = 0:(size/10):size
%        line([0 size], [i i], 'color', 'k')
%        line([i i], [0 size], 'color', 'k')
%     end

    %% Init Location of all Nodes
    for i = 1:numNode
        location_Mat(i,:) = [floor(rand() * map_size) floor(rand() * map_size)]; %#ok<*AGROW>
%         plot(location_Mat(i,1), location_Mat(i,2), 'ob','MarkerEdgeColor', 'b', 'MarkerSize', 15); %#ok<*NODEF>
%         text(location_Mat(i,1), location_Mat(i,2),sprintf('%d',i), 'HorizontalAlignment', 'center');
    end

    %% Load Traffic
    for i = 1:numNode
        if i <= numNode - 96
            % Traffic between nút i và i +96 = 1
            set_traffic(i, i + 96, 1);
        end

        if i <= numNode - 56
            % Traffic between nút i và i +56 = 1 
            set_traffic(i, i + 56, 1);
        end

    end
    % Traffic between nút 10 và nút 18 = 35. 
    set_traffic(10, 18, 35);

    % Traffic between nút 37 và 69 = 32, 
    set_traffic(37, 69, 32);

    % Traffic between nút 48 và 72 = 3, 
    set_traffic(48, 72, 3);

    % Traffic between nút 18 và 76 = 4
    set_traffic(18, 76, 3);
    
    %% Set Weight for all nodes - Trong so = tong tat ca luu luong vao ra nut
    for i = 1:numNode
        weight_Mat(i) = sum(traffic_Mat(i, :));
    end
    
    dist_Mat = zeros(numNode);
    for i = 1:numNode
        for j = 1:numNode
            dist_Mat(i,j) = norm(location_Mat(i,:) - location_Mat(j,:));
        end
    end
    
    

    %% Nested function
        function set_traffic(src, des, value)
            traffic_Mat(src, des) = traffic_Mat(src, des) + value;
            traffic_Mat(des, src) = traffic_Mat(des, src) + value;
        end
end

