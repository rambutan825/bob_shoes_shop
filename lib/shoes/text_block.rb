require 'shoes/common_methods'
require 'shoes/common/margin'

module Shoes
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock
    include Shoes::CommonMethods
    include Shoes::Common::Margin

    attr_reader  :gui, :parent, :text, :links, :app
    attr_accessor :font, :font_size, :width, :height, :left, :top

    def initialize(parent, text, font_size, opts = {})
      @parent = parent
      @font = DEFAULT_TEXTBLOCK_FONT
      @font_size = opts[:size] || font_size
      @text = text
      @left = opts[:left]
      @top = opts[:top]
      @links = []
      @app = @parent.app

      @margin = opts[:margin]
      set_margin

      handle_opts opts

      @gui = Shoes.configuration.backend_for(self, opts)
      if text.split.length == 1
        @width, @height = @gui.get_size
        @fixed = true
      end
      @left && @top ? set_size(@left.to_i, @left.to_i) : @parent.add_child(self)
    end

    def move left, top
      set_size left, top unless @fixed
      super
    end

    # It might be possible to leave the redraw
    # function blank for non-SWT versions of Shoes
    def text=(value)
      @text = value.to_s
      @gui.redraw
    end

    def replace(*args)
      opts = args.last.class == Hash ? args.pop : {}
      styles = get_styles args
      opts[:args_styles] = styles unless styles.empty?
      self.text = args.map(&:to_s).join
      # forgive me for my sins.
      gui.instance_eval { @painter.instance_eval { @opts[:text_styles] = styles unless styles.empty? }}
    end

    def to_s
      self.text
    end

    def positioning x, y, max
      set_size @left.to_i, @top.to_i
      super
    end

    def set_size left, top
      unless @fixed
        @width = (left + @parent.width <= app.width) ? @parent.width : app.width - left
      end
      @height = @gui.get_height + @margin_top + @margin_bottom
    end

    private

    def handle_opts(opts)
      if opts.has_key? :family
        parse_font_opt opts[:family]
      end
    end

    def parse_font_opt(type)
      size_regex = /\d+(?=px)?/
      style_regex = /none|bold|normal|oblique|italic/i # TODO: add more

      ffamily = type.gsub(style_regex,'').gsub(/\d+(px)?/,'').
                  split(',').map { |x| x.strip.gsub(/["]/,'') }

      @font = ffamily.first unless (ffamily.size == 1 and
        ffamily[0] == "") or ffamily.size == 0

      fsize = type.scan(size_regex)
      @font_size = fsize.first.to_i unless fsize.empty?

      # TODO: Style options
    end

    # this is copy-pasta from lib/shoes/element_methods
    # we need something equivalent accessible from here.
    # maybe the other version already is, but if so, i didn't
    # immediately see how to access it.
    def get_styles msg, styles=[], spoint=0
      msg.each do |e|
        if e.is_a? Shoes::Text
          epoint = spoint + e.to_s.length - 1
          styles << [e, spoint..epoint]
          get_styles e.str, styles, spoint
        end
        spoint += e.to_s.length
      end
      styles
    end
  end

  class Banner < TextBlock; end
  class Title < TextBlock; end
  class Subtitle < TextBlock; end
  class Tagline < TextBlock; end
  class Caption < TextBlock; end
  class Para < TextBlock; end
  class Inscription < TextBlock; end
end
