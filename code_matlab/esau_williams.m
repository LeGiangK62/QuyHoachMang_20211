function [all_link] = esau_williams(w_ew, link_cost, status_Mat, weight_Mat, depth)
% Esau - Williams algorithm
% input:    w_ew - weight max; 
%           link_cost - link cost matrix;
%           status_Mat - status Matrix
% 
% Trong bai nay link_cost = distance
    numNode = length(status_Mat);
    all_link = [];
    
    backbone = [];
    for i = 1:numNode
        if status_Mat(i) == -1
            backbone = [backbone; i]; %#ok<*AGROW>
        end
    end
    
    next_hop = zeros(numNode,1);
    
    % E-W for each backbone
    for eachBb = 1:length(backbone)
        cur_Bb = backbone(eachBb);
        access = [];


        for i = 1:numNode
                if status_Mat(i) == cur_Bb
                    access = [access; [i 0]]; 
                end
        end
        
        %% Each Tree - Tu day lam viec vs index nho
        numAccess = size(access,1);
        
        if not(numAccess)
            continue;
        end

        %%
        %Ma tran link cost doi voi cac node trong cay
        link_cost_access = zeros(numAccess, numAccess + 1);

        next_hop_access = zeros(numAccess, 1);

        cost_to_bb = [];
        
        next_to_bb = zeros(numAccess,1);
        for i = 1:numAccess
            cost_to_bb = [cost_to_bb; link_cost(access(i,1), cur_Bb)];
            next_hop_access(i) = numAccess + 1;
            next_to_bb(i) = i;

            link_cost_access(i,numAccess + 1) = link_cost(access(i,1), cur_Bb);
            for j = 1:numAccess
                link_cost_access(i, j) = link_cost(access(i,1), access(j,1));
                if i == j
                    link_cost_access(i, j) = +inf;
                end
            end
        end
        %%
        % Tinh thoa hiep
        T_mat = zeros(numAccess,1);
        best_hop = zeros(numAccess,1);
        for i = 1:numAccess

            if access(i,2)
                continue;
            end

            [min_link, best_hop(i)] = min(link_cost_access(i,:));
            T_mat(i) = min_link - cost_to_bb(i);

            if T_mat(i) >= 0
                access(i,2) = 1; %Thoa hiep duong
                
            end
        end


        %% Vong lap cap nhat Trade-off
        while(ismember(0,access(:,2)))


            %Tim min thoa hiep
            [~, min_i] = min(T_mat);
            
            new_hop = best_hop(min_i);
%             w_ew = 10;
%             if (min_i == 44) 
%                 w_ew = 11;
%             end
%             
            if (next_to_bb(min_i) == next_to_bb(new_hop))
                %Neu new_hop cung nhanh voi current node
                link_cost_access(min_i, new_hop) = inf;
                link_cost_access(new_hop, min_i) = inf;
                for i = 1:numAccess

                    if access(i,2)
                        continue;
                    end

                    [min_link, best_hop(i)] = min(link_cost_access(i,:));
                    T_mat(i) = min_link - cost_to_bb(i);

                    if (T_mat(i) >= 0) 
                        access(i,2) = 1; %Thoa hiep duong
                    end
                end
                continue;
            end

            %Kiem tra dieu kien trong so
            sum_w = 0;
            
            cur_branch = next_to_bb(min_i);
            new_branch = next_to_bb(new_hop);
            for i = 1:numAccess
               if (next_to_bb(i) == cur_branch) || (next_to_bb(i) == new_branch)
                   sum_w = sum_w + weight_Mat(access(i,1));
               end
            end
            
            %Test depth
            over_deep = 0;
            if depth
                %xay dung link_temp de xet node.
                next_hop_temp = next_hop_access;
                next_to_bb_temp = next_to_bb;
                %Noi duong moi 

                cur_loop = min_i;
                if next_hop_temp(cur_loop) ~= (numAccess + 1)
                    %Neu min_i noi vao node khac
                    %=> Dao nguoc toan bo nhanh prev va next

                    cur_branch = next_to_bb_temp(min_i);

                    cur_loop = (min_i);
                    need_reverse = [min_i];
                    while cur_loop ~= cur_branch
                        cur_loop = next_hop_temp(cur_loop);
                        if ismember(cur_loop, need_reverse)
                            break;
                        end
                        need_reverse = [need_reverse cur_loop];
                    end

                    for i = 2:length(need_reverse)
                        next_hop_temp(need_reverse(i)) = need_reverse(i - 1);
                    end

                end


                next_hop_temp(min_i) = new_hop;

                 % Cap nhat nut next_to_bb => branch index
                % Update cho tat ca cac node trong branch
                for i = 1:numAccess
                    if next_to_bb_temp(i) == cur_branch
                        next_to_bb_temp(i) = next_to_bb_temp(new_hop);
                    end
                end

                for i = 1:numAccess
                     if next_to_bb_temp(i) == next_to_bb_temp(new_hop)
                        cur_depth = 1;
                        cur_loop = i;
                        while cur_loop ~= numAccess + 1
                            cur_depth = cur_depth + 1;
                            cur_loop = next_hop_temp(cur_loop);
                        end

                        if cur_depth > depth
                            over_deep = 1;
                            break;
                        end
                     end
                end
            end


            if (sum_w <= w_ew) && not(over_deep)
                %%
 
                %% Thoa man DK - cap nhat node noi trung tam

                %Xoa duong cu
                link_cost_access(min_i, next_hop_access(min_i)) = inf;
                link_cost_access(next_hop_access(min_i), min_i) = inf;
                link_cost_access(min_i, new_hop) = inf;
                link_cost_access(new_hop, min_i) = inf;

                %Noi duong moi 

                cur_loop = min_i;
                if next_hop_access(cur_loop) ~= (numAccess + 1)
                    %Neu min_i noi vao node khac
                    %=> Dao nguoc toan bo nhanh prev va next

                    cur_branch = next_to_bb(min_i);

                    cur_loop = (min_i);
                    need_reverse = [min_i];
                    while cur_loop ~= cur_branch
                        cur_loop = next_hop_access(cur_loop);
                        if ismember(cur_loop, need_reverse)
                            break;
                        end
                        need_reverse = [need_reverse cur_loop];
                    end

                    for i = 2:length(need_reverse)
                        next_hop_access(need_reverse(i)) = need_reverse(i - 1);
                    end

                end


                next_hop_access(min_i) = new_hop;

                cost_to_bb(min_i) = cost_to_bb(new_hop);%cai nay cung la vong lap vi anh hg toi ca nhanh?

                 % Cap nhat nut next_to_bb => branch index
                % Update cho tat ca cac node trong branch
                for i = 1:numAccess
                    if next_to_bb(i) == cur_branch
                        next_to_bb(i) = next_to_bb(new_hop);
                        cost_to_bb(i) = cost_to_bb(new_hop);
                    end
                end
                    

            else
                %Khong thoa man DK
                link_cost_access(min_i, new_hop) = inf;
                link_cost_access(new_hop, min_i) = inf;
            end

            %Cap nhat thoa hiep

            for i = 1:numAccess

                if access(i,2)
                    continue;
                end

                [min_link, best_hop(i)] = min(link_cost_access(i,:));
                T_mat(i) = min_link - cost_to_bb(i);

                if (T_mat(i) >= 0) 
                    access(i,2) = 1; %Thoa hiep duong
                end
            end


        end
        %Cap nhat ma tran next_hop
        for i = 1:numAccess
            if next_hop_access(i) == numAccess + 1
                next_hop(access(i,1)) = cur_Bb;
            else
                next_hop(access(i,1)) = access(next_hop_access(i),1);
            end
           
        end
        
    end
    
    for i = 1:numNode
        if status_Mat(i) == -1
            continue;
        end
        if (next_hop(i) && i) == 0
            continue;
        end
        all_link = [all_link; [i next_hop(i)]];
    end
            

end
