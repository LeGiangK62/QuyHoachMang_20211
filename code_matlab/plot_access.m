function plot_access(location_Mat, status_Mat, all_link)

    numNode = size(status_Mat,1);
    for i = 1:numNode
       if status_Mat(i) == -1         
           cur_map = [];
           for j = 1:numNode
              if status_Mat(j) == i
                 cur_map = [cur_map; j]; 
              end
           end
           cur_map = [cur_map; i];
           cur_link = [];
           for i = 1:size(all_link,1)
               des = all_link(i,1);
               src = all_link(i,2);
               if ismember(des, cur_map) && ismember(src, cur_map)
                   cur_link = [cur_link; all_link(i,:)];
               end
           end
           
           plot_all(0, location_Mat, status_Mat, cur_link);
       end
    end

end