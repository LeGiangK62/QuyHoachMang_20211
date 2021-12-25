function total_cost = cost_link(link_cost, all_link)
    total_cost = 0;
    for i = 1:size(all_link,1)
        curr_node = all_link(i,1);
        next_node = all_link(i,2);
        total_cost = total_cost + link_cost(curr_node,next_node);
    end
end