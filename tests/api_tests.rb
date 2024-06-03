
require "test/unit"
require 'test/unit/ui/console/testrunner'

# NOTE: these tests are more like smoke tests
# For the real tests, see "run_tests.sh"

class XSectionAPITest < Test::Unit::TestCase
 
  def test_run

    mw = RBA::MainWindow.instance
    mw.load_layout($input_file, 1)

    cv = RBA::CellView.active

    gen = XS::XSectionGenerator.new($xs_file)
    view = gen.run(RBA::DPoint.new(-1, 0), RBA::DPoint.new(1, 0), cv)

    assert_equal("(-0.042,-2.058;2.058,0.042)", view.box.to_s)

  end
 
  def test_run_multi

    mw = RBA::MainWindow.instance
    mw.load_layout($input_file, 1)

    cv = RBA::CellView.active

    gen = XS::XSectionGenerator.new($xs_file)
    view = gen.run_multi([[ RBA::DPoint.new(-1, 0), RBA::DPoint.new(0, 0) ], [ RBA::DPoint.new(0, 0), RBA::DPoint.new(1, 0) ]], cv)

    assert_equal("(-0.042,-2.058;2.058,0.042)", view.box.to_s)

  end
 
end

test_suite = XSectionAPITest.suite
Test::Unit::UI::Console::TestRunner.run(test_suite)

