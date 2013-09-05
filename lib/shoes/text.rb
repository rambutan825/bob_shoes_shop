class Shoes
  class Text
    def initialize m, str, color=nil
      @style, @str, @color = m, str, color
      @to_s = str.map(&:to_s).join
    end
    attr_reader :to_s, :style, :str, :color
    attr_accessor :parent
    def app
      @parent.app
    end
  end
  
  class Link < Text
    def initialize m, str, color=nil, &blk
      @blk = blk
      super m, str, color
    end
    attr_reader :blk
    attr_accessor :click_listener, :lh, :start_x, :start_y, :end_x, :end_y, :parent_left, :parent_width,
                  :clickabled, :parent
    
    def in_bounds?(x, y)
      if parent_width
        (
          (parent_left..(parent_left + parent_width)).include?(x) and
          (start_y..end_y).include?(y) and
          !(
            (parent_left..start_x).include?(x) and
            (start_y..(start_y + lh)).include?(y)
          ) and
          !(
            (end_x..(parent_left + parent_width)).include?(x) and
            ((end_y-lh)..end_y).include?(y)
          )
        )
      end
    end
  end

  class Span < Text
    attr_reader :opts

    def initialize str, opts={}
      @opts = opts
      super :span, str
    end
  end
end
