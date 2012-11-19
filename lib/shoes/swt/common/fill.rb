module Shoes
  module Swt
    module Common
      # Methods for retrieving fill values from a Shoes DSL class
      #
      # @note Including classes must provide `#dsl`
      module Fill
        # This object's fill color
        #
        # @return [Swt::Graphics::Color] The Swt representation of this object's fill color
        def fill
          ::Shoes::Swt::Color.create(dsl.fill)
        end

        # This object's fill alpha value
        #
        # @return [Integer] The alpha value of this object's fill color (0-255)
        def fill_alpha
          ::Shoes::Swt::Color.new(dsl.fill)
        end

        def apply_fill(context)
          fill.apply_as_fill(context)
        end
      end
    end
  end
end
