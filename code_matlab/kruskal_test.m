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
location_Mat = [1+x     1+2*x; %A
                1       1+x; %B
                1       1; %C
                1+x     1+x; %D
                1+x     1; %E
                1+2*x   1; %F
                1+2*x   1+x; %G
                1+2*x   1+2*x %H
                ];
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
    
    for i = 1:length(link_cost_vec_sort)
        cur_link = link_cost_vec_sort(i,1);
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
        
        if des_check && src_check
             % des_check && src_check == 1 => both are already added => continue
            continue;
        end
        
        %%
        
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
        
        disp(sum_w);
        
        if sum_w >= w_ew
           %Khong add duong do
            continue;
        end
        
        %%
        
        if not(des_check || src_check)
            %des_check || src_check == 0 => both are new 
            added_list = [added_list; cur_des];
            added_list = [added_list; cur_src];
            
            branch(cur_des) = cur_des;
            branch(cur_src) = cur_des;
            
            link_list = [link_list; i];

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


end

plot_all(0, location_Mat, status_Mat, link_list);