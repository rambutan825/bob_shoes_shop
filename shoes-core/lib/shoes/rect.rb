class Shoes
  class Rect
    include Common::UIElement
    include Common::Fill
    include Common::Stroke
    include Common::Clickable
    include Common::Hover
    include Common::Style
    include Common::Translate

    style_with :angle, :art_styles, :curve, :common_styles, :dimensions
    STYLES = { angle: 0, curve: 0, fill: Shoes::COLORS[:black] }.freeze

    def create_dimensions(left, top, width, height)
      left   ||= @style[:left] || 0
      top    ||= @style[:top] || 0
      width  ||= @style[:width] || 0
      height ||= @style[:height] || width

      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
    end

    def needs_rotate?
      rotate && rotate.nonzero?
    end
  end
end
