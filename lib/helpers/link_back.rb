def find_parent(identifier_string)
  parent_glob = identifier_string.sub(%r{/[^/]+\z}, '') + '.*'

  parent = @items[parent_glob]
  if parent
    parent
  elsif parent_glob != '.*'
    find_parent(parent_glob)
  else
    nil
  end
end

def link_back
  parent = find_parent(item.identifier.to_s)
  siblings =
    if parent
      @items
        .find_all(parent.identifier.without_ext + '/*')
        .sort_by { |i| i[:title] }
    else
      []
    end

  index = siblings.find_index { |i| i == @item }

  next_item = index && index < siblings.size ? siblings[index+1] : nil
  prev_item = index && index > 0 ? siblings[index-1] : nil

  if parent || next_item || prev_item
    s = []

    if parent
      s << ['↑ ' + link_to("Back to #{parent[:short_title] || parent[:title]}", parent)]
    end

    if prev_item
      s << ['&larr; ' + link_to("Previous (#{prev_item[:short_title] || prev_item[:title]})", prev_item)]
    end

    if next_item
      s << ['&rarr; ' + link_to("Next (#{next_item[:short_title] || next_item[:title]})", next_item)]
    end

    '<p>' + s.join('<br>') + '</p>'
  else
    ''
  end
end
