require 'swt'

module Shoes
  module Swt
    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #

    class App
      include Common::Container

      def initialize dsl
        @dsl = dsl
        @real = ::Swt::Widgets::Shell.new(::Swt.display, main_window_style).tap do |shell|
          shell.set_image ::Swt::Graphics::Image.new(::Swt.display, SHOES_ICON)
          shell.setText(@dsl.app_title)
          shell.addListener(::Swt::SWT::Close, main_window_on_close)
          shell.background_mode = ::Swt::SWT::INHERIT_DEFAULT
          shell.setBackground @dsl.default_options[:background].to_native
        end
        @shell = @real
        @real = ::Swt::Widgets::Composite.new(@shell, ::Swt::SWT::TRANSPARENT)
        @real.setSize(@dsl.width, @dsl.height)
        @real.setLayout ShoesLayout.new

        @dx = @dy = 0
        @shell.addControlListener ShellControlListener.new(self)
      end

      attr_reader :dsl, :real, :shell, :dx, :dy

      def open
        @shell.pack
        @shell.open
        @dx, @dy = @shell.getSize.x - @dsl.width, @shell.getSize.y - @dsl.height

        ::Swt.event_loop { ::Swt.display.isDisposed }

        Shoes.logger.debug "::Swt.display disposed... exiting Shoes::App.new"
      end

      # @return [Shoes::Swt::App] Self
      def app
        self
      end

      private
      def main_window_on_close
        lambda { |event|
          Shoes.logger.debug "main_window on_close block begin... disposing ::Swt.display"
          ::Swt.display.dispose
          Shoes.logger.debug "::Swt.display disposed"
        }
      end

      def main_window_style
        style  = ::Swt::SWT::CLOSE | ::Swt::SWT::MIN | ::Swt::SWT::MAX
        style |= ::Swt::SWT::RESIZE if @dsl.opts[:resizable]
        style
      end
    end

    class ShellControlListener
      def initialize(app)
        @app = app
        super()
      end

      def controlResized(e)
        shell = e.widget
        w, h = shell.getSize.x - @app.dx, shell.getSize.y - @app.dy
        (@app.dsl.top_slot.width, @app.dsl.top_slot.height = w, h) if @not_the_first_time
        @not_the_first_time = true
        @app.real.setSize w, h
      end

      def controlMoved(e)
      end
    end

  end
end

