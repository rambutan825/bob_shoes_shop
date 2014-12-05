class Shoes
  class Timer
    include Common::Inspect

    def initialize(app, n = 1000, &blk)
      @app = app
      @n   = n
      @blk = @app.current_slot.create_block_bound_to_slot(blk)
      @gui = Shoes.configuration.backend_for(self, @app.gui, @blk)
    end

    attr_reader :n, :gui
  end
end
