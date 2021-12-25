function disp_line(curr_node, next_node, location_Mat)

    line([location_Mat(curr_node,1), location_Mat(next_node,1)], [location_Mat(curr_node,2), location_Mat(next_node,2)],'color', 'k');

end