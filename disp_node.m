function disp_node(id, location_Mat, is_Bb)
    if is_Bb
        plot(location_Mat(id,1), location_Mat(id,2), 'ob','MarkerFaceColor', 'b', 'MarkerSize', 15); %#ok<*NODEF>
        text(location_Mat(id,1), location_Mat(id,2),sprintf('%d',id), 'HorizontalAlignment', 'center', 'Color', 'w');
    else
        plot(location_Mat(id,1), location_Mat(id,2), 'ob','MarkerEdgeColor', 'b', 'MarkerSize', 15); %#ok<*NODEF>
        text(location_Mat(id,1), location_Mat(id,2),sprintf('%d',id), 'HorizontalAlignment', 'center', 'Color', 'k');
    end

end