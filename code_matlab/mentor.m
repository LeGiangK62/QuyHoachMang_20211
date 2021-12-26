function [status_Mat] = mentor(w_mentor, R, C, weight_Mat, location_Mat)
% Mentor algorithm with 
% input w - weight, r - radius, c - capacity
    numNode = length(weight_Mat);
    % Phan loai cac nut Backbone: 
    
    %% Phan loai dua vao gia tri nguong
    % W / C so sanh vs w_mentor
    status_Mat = zeros(numNode,1); 
    % Status Matrix:    -1  - backbone
    %                   x   - access of backbone x
    %                   0   - uncatergorized
    backbone = [];
    for i = 1:numNode
        if (weight_Mat(i)/C) > w_mentor
            status_Mat(i) = -1;
            backbone = [backbone i]; %#ok<*AGROW>
        end
        
    end
    
    % Tinh max_cost
        dist_Mat = zeros(numNode);
        for i = 1:numNode
            for j = 1:numNode
                dist_Mat(i,j) = norm(location_Mat(i,:) - location_Mat(j,:));
            end
        end
        max_cost = max(max(dist_Mat));
        R_max_cost = R * max_cost;
    %%% Loop here?    
    while(ismember(0,status_Mat)) %Loop khi van chua phan loai het
        if backbone
%             disp('Danh sach cac nut backbone:');
%             disp(backbone);


            % Them cac nut access
            for i = 1:length(backbone)
                for j = 1:numNode
                    if (dist_Mat(backbone(i),j) < R_max_cost) && not(status_Mat(j))
                        status_Mat(j) = backbone(i);
                    end    
                end
            end
        end
        
        if not(ismember(0,status_Mat)) %Ktra xem con nut chua phan loai ko?
            return
        end
        %% Phan loai dua vao gia tri thuong:
        %Tim nut trung tam
        x_ctr = 0; y_ctr = 0; w_ctr = 0;
        uncatergorized = [];
        for i = 1:numNode
            if not(status_Mat(i))
                x_ctr = x_ctr + location_Mat(i,1) * weight_Mat(i);
                y_ctr = y_ctr + location_Mat(i,2) * weight_Mat(i);
                w_ctr = w_ctr + weight_Mat(i);
                uncatergorized = [uncatergorized; [i 0 0 0]]; % empty slot for dc and merit
            end
        end
        location_ctr = [x_ctr/w_ctr, y_ctr/w_ctr];

        for i = 1:length(uncatergorized(:,1))
            uncatergorized(i,2) = norm(location_Mat(uncatergorized(i,1)) - location_ctr);
            uncatergorized(i,3) = weight_Mat(uncatergorized(i,1));
        end

        dc_max = max(uncatergorized(:,2));
        w_max = max(uncatergorized(:,3));
        uncatergorized(:,4) = 0.5 * ((uncatergorized(:,2) - dc_max)/dc_max) + 0.5 * ((uncatergorized(:,3))/w_max);


        [~, new] = max(uncatergorized(:,4));

        status_Mat(uncatergorized(new,1)) = -1;
        backbone = [backbone uncatergorized(new,1)];
        
    end
    
%     %Plot mau them cho backbone
%     figure();
%     hold on;
%     for i = 1: numNode
%         if status_Mat(i) == -1
%             disp_node(i, location_Mat, 1);
%         else
%             disp_node(i, location_Mat, 0);
%         end
%     end
%     hold off;
    
    
    %% Nested function
    
    
end