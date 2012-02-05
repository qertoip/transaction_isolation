
def run_test_case( path )
  system( "ruby -I\"test:lib\" #{path}" )
end

def send_tray_notification
  tests_passed = $?.exitstatus.zero?

  if tests_passed
    system( "notify-send --urgency=normal --icon=#{Dir.getwd}/test/icons/pass.png \"Tests passed\"" )
  else
    system( "notify-send --urgency=normal --icon=#{Dir.getwd}/test/icons/fail.png \"Tests failed\"" )
  end
end

watch( 'test/units/.*_test\.rb', 'test/integration/.*_test\.rb' ) do |md|
  path = md[0]
  run_test_case( path )
  send_tray_notification
end

watch( 'lib/(.*)\.rb' ) do |md|
  path = "test/#{md[1]}_test.rb".gsub( "konto_lib/", "units/" )
  run_test_case( path )
  send_tray_notification
end
