module SlugfilterHelper
  def walk_slug_tree(tree, depth=nil, format=:html, &block)
    capture_haml do
      if format == :json then
        walk_slug_tree_json(tree, nil, true, depth, &block)
      else
        walk_slug_tree_helper(tree, nil, true, depth, &block)
      end
    end
  end

  def walk_slug_tree_json(tree, step=nil, odd=true, depth=nil, &block)
    children = tree.first_level_descendents_with_step

    if tree.object && !depth.nil?
      depth = depth - 1
      children = [] if depth <= 0
    end

    haml_concat "{"
    if tree.object || !children.empty?
      if tree.object
        yield [tree.object, step, depth]
        if !children.empty?
          haml_concat ", "
        end
      end
      if !children.empty?
        index = 0
        haml_concat "\"children\" : ["
        children.each do |step, child|
          if index > 0
            haml_concat ","
          end
          index = 1
          walk_slug_tree_json(child, step, odd, &block)
        end
        haml_concat "]"
      end
    end
    haml_concat "}"
  end

  def walk_slug_tree_helper(tree, step=nil, odd=true, depth=nil, &block)
    children = tree.first_level_descendents_with_step

    if tree.object && !depth.nil?
      depth = depth - 1
      children = [] if depth <= 0
    end

    if tree.object || !children.empty?
      haml_tag("li", { :id => "content_#{tree.prefix}" }) do
        if tree.object
          yield [tree.object, step, depth]
        end
        if !children.empty?
          haml_tag("ul", { :id => "children_#{tree.prefix}" }) do
            children.each do |step, child|
              walk_slug_tree_helper(child, step, odd, depth, &block)
            end
          end
        end
      end
    end
  end
end
