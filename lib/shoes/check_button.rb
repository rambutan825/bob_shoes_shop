class Shoes
  class CheckButton
    include Common::UIElement
    include Common::Clickable
    include Common::State

    attr_reader :app, :parent, :blk, :gui, :dimensions

    def initialize(app, parent, opts = {}, blk = nil)
      @app        = app
      @parent     = parent
      @blk        = blk
      @dimensions = Dimensions.new parent, opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      register_click(opts)
      state_options(opts)
    end

    def checked?
      @gui.checked?
    end

    def checked=(value)
      @gui.checked = value
    end

    def focus
      @gui.focus
    end

    def click
      @blk.call if blk
    end
  end

  class Check < CheckButton ; end


end
