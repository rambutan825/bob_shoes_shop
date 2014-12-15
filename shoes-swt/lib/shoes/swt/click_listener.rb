class Shoes
  module Swt
    # This class is intended as the single click listener held onto by the app.
    # That lets us control dispatch of events to our DSL objects however we
    # please, instead of relying on whatever SWT thinks is right. See #882.
    class ClickListener
      attr_reader :clickable_elements

      def initialize
        @clickable_elements = []
      end

      def add_click_listener(swt)
        add_clickable_element(swt.dsl)
      end

      def add_release_listener(swt)
        add_clickable_element(swt.dsl)
      end

      def add_clickable_element(dsl)
        @clickable_elements << dsl unless @clickable_elements.include?(dsl)
      end
    end
  end
end
