require 'spec_helper'

describe Shoes::Swt::Gradient do
  let(:color1) { Shoes::Color.create(Shoes::COLORS[:honeydew]) }
  let(:color2) { Shoes::Color.create(Shoes::COLORS[:salmon]) }

  let(:applied_to) do
    double("applied to", element_left: 0, element_top: 0, angle: 0,
                         element_width: 10, element_height: 10)
  end

  let(:dsl) { Shoes::Gradient.new(color1, color2) }
  let(:gc) { double("gc", set_background_pattern: nil) }

  subject { Shoes::Swt::Gradient.new(dsl) }

  it_behaves_like "an swt pattern"

  describe "#dispose" do
    it "lets subresources do" do
      # Prime the object's lazy colors
      subject.apply_as_fill(gc, applied_to)

      expect(subject.color1).to receive(:dispose)
      expect(subject.color2).to receive(:dispose)

      subject.dispose
    end
  end

  describe "#apply_as_fill" do
    it "sets background" do
      expect(gc).to receive(:set_background_pattern)
      subject.apply_as_fill(gc, applied_to)
    end
  end
end
