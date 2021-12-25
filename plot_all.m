function plot_all(map_size, location_Mat, status_Mat, all_link)

    numNode = length(status_Mat);
    figure();
    hold on;
    axis equal;
    
    if map_size
        rectangle('Position',[0 0 map_size map_size])
        axis([-50 map_size+50 -50 map_size+50]);

        for i = 0:(map_size/10):map_size
           line([0 map_size], [i i], 'color', 'k')
           line([i i], [0 map_size], 'color', 'k')
        end
    else
        grid on;
    end
    
    for i = 1: numNode
        if not(ismember(i,all_link)) && not(map_size)
            continue;
        end
        if status_Mat(i) == -1
            disp_node(i, location_Mat, 1);
        else
            disp_node(i, location_Mat, 0);
        end
    end
    
    if all_link
        for i = 1:size(all_link,1)
            curr_node = all_link(i,1);
            next_node = all_link(i,2);
            disp_line(curr_node, next_node, location_Mat);
        end
        
    end
    
    hold off;
end
