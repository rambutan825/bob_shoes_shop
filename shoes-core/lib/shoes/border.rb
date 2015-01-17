class Shoes
  class Border
    include Common::Initialization
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui

    style_with :angle, :common_styles, :curve, :dimensions, :stroke, :strokewidth
    STYLES = { angle: 0, curve: 0 }

    def before_initialize(styles, color)
      styles[:stroke] = color
    end

    def create_dimensions(*_)
      @dimensions = ParentDimensions.new @parent, @style
    end
  end
end
