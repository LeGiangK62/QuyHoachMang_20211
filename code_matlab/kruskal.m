function all_link = kruskal(w_ew, link_cost, status_Mat, weight_Mat)
    all_link = [];
    numNode = length(status_Mat);

    backbone = [];
    for i = 1:numNode
        if status_Mat(i) == -1
            backbone = [backbone; i]; %#ok<*AGROW>
        end
    end

    for eachBb = 1:length(backbone)
        cur_Bb = backbone(eachBb);
        access = [];


        for i = 1:numNode
                if status_Mat(i) == cur_Bb
                    access = [access; i]; 
                end
        end

        %% Each Tree - Tu day lam viec vs index nho
        numAccess = size(access,1);

        if not(numAccess)
            continue;
        end

        %%
        %Ma tran link cost doi voi cac node trong cay
        link_cost_vec = [];
        for i = 1:numAccess
            link_cost_vec = [link_cost_vec; [link_cost(access(i), cur_Bb), i, numAccess + 1]];

            for j = i:numAccess
                if j == i
                    continue;
                end
                link_cost_vec = [link_cost_vec; [link_cost(access(i), access(j)), i, j]];
            end
        end

    %     link_cost_vec = reshape(link_cost_access,[],1);
    %     
        link_cost_vec_sort = sortrows(link_cost_vec,1);

        added_list = [];
        branch = zeros(numAccess,1);
        link_list = [];
        link_to_Bb = [];

        for i = 1:size(link_cost_vec_sort,1)
            cur_des = link_cost_vec_sort(i,2);
            cur_src = link_cost_vec_sort(i,3);
            
            %Check loop
            des_check = ismember(cur_des,added_list);
            src_check = ismember(cur_src,added_list);

            if (cur_des == numAccess + 1) || (cur_src == numAccess + 1)
                %1 trong 2 la Backbone
                if (cur_des == numAccess + 1)
                    if ismember(branch(cur_src), link_to_Bb)
                        continue;
                    else    
                        if src_check
                            %Node con lai da thuoc list
                        else
                            added_list = [added_list; cur_src];
                            branch(cur_src) = cur_src;
                        end 
                        link_list = [link_list; i];
                        link_to_Bb = [link_to_Bb; branch(cur_src)];
                       
                    end
                end

                if (cur_src == numAccess + 1)
                    if ismember(branch(cur_des), link_to_Bb)
                        continue;
                    else    
                        if des_check
                            %Node con lai da thuoc list
                        else
                            added_list = [added_list; cur_des];
                            branch(cur_des) = cur_des;
                        end 
                        link_list = [link_list; i];
                        link_to_Bb = [link_to_Bb; branch(cur_des)];
                    end
                end
                continue;
            end
            
            if (branch(cur_src) == branch(cur_des)) && branch(cur_src)
                %2 node cung branch => loop
                continue;
            end
            
            if not(des_check || src_check)
                %des_check || src_check == 0 => both are new 
                if (weight_Mat(access(cur_des)) + weight_Mat(access(cur_src))) <= w_ew
                    
                    added_list = [added_list; cur_des];
                    added_list = [added_list; cur_src];

                    branch(cur_des) = cur_des;
                    branch(cur_src) = cur_des;

                    link_list = [link_list; i];
                end
                
                continue;
            end

            if (des_check && src_check) 
                % des_check && src_check == 1 => both are already added
                if (ismember(branch(cur_src), link_to_Bb) && ismember(branch(cur_des), link_to_Bb))
                  % both have connect to Bb => continue
                  continue;
                      
                else
                    if ismember(branch(cur_src), link_to_Bb)
                        %src da link to Bb => not des vao src, doi branch
                        %src
                        cur_node = cur_des;
                        cur_branch  = branch(cur_src);   
                        old_branch  = branch(cur_des);
                    end
                    
                    if ismember(branch(cur_des), link_to_Bb)
                        %src da link to Bb => not des vao src, doi branch
                        %src
                        cur_node = cur_src;
                        cur_branch  = branch(cur_des);  
                        old_branch  = branch(cur_src);
                    end
                    
                    if not(ismember(branch(cur_src), link_to_Bb) || ismember(branch(cur_des), link_to_Bb))
                  % both have connect to Bb => continue
                        cur_node = cur_des;
                        cur_branch  = branch(cur_src);   
                        old_branch  = branch(cur_des);
                    end
                    
                    sum_w = 0;
                    
                    for j = 1:numAccess
                       if (branch(j) == cur_branch) || (branch(j) == old_branch)
                           sum_w = sum_w + weight_Mat(access(j));
                       end
                    end


                    if sum_w > w_ew
                       %Khong add duong do
                        continue;
                    end
                    
                    for cur_node = 1:numAccess
                        if branch(cur_node) == old_branch
                           branch(cur_node) = cur_branch; 
                        end
                    end

                    %Them link
                    link_list = [link_list; i];
                    continue;  
                end   
            end
            
            
            if des_check
                %des added => adding src
                cur_node = cur_src;
                cur_branch  = branch(cur_des);
            else
                %src added => adding des
                cur_node = cur_des;
                cur_branch  = branch(cur_src);
            end


            
            
            %Check trong so
            sum_w = 0;

            for j = 1:numAccess
               if branch(j) == cur_branch
                   sum_w = sum_w + weight_Mat(access(j));
               end
            end
            

            if sum_w > w_ew
               %Khong add duong do
                continue;
            end

            %Thoa man 2 dk tren
            %Add vao list
            added_list = [added_list; cur_node];
            branch(cur_node) = cur_branch;
            
            %Them link
            link_list = [link_list; i];

            not_done = 0;
            for id = 1:numAccess
               if  not(ismember(branch(id), link_to_Bb))
                   not_done = 1;
                   break;
               end
            end

            if not_done
                continue;
            end

            %Check ket thuc thuat toan
            if size(added_list,1) == numAccess
                break;
            end 
        end

        %Plot each Bb
%         figure();
%         hold on;

%         disp_node(cur_Bb, location_Mat, 1);

%         for i = 1:numAccess
%             disp_node(access(i), location_Mat, 0);
%         end

        for i = 1:length(link_list)
            curr_node = link_cost_vec_sort(link_list(i),2);
            next_node = link_cost_vec_sort(link_list(i),3);

            if curr_node == numAccess + 1
                curr_node = cur_Bb;
            else
                curr_node = access(curr_node);
            end

            if next_node == numAccess + 1
                next_node = cur_Bb;
            else
                next_node = access(next_node);
            end

            all_link = [all_link; [curr_node, next_node]];
%             disp_line(curr_node, next_node, location_Mat)
        end
%         hold off; 


    end
end