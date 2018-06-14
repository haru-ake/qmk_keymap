require 'rake'

QMK_PATH = "#{Dir.pwd}/qmk_firmware"

def qmk_submodule?
  r = `git submodule status`
  $?.success? && !r.empty?
end

def avr_gcc?
  `which avr-gcc > /dev/null 2>&1`; $?.success?
end

def keyboard_revision(keyboard)
  ENV['subproject'] ? "#{keyboard}/#{ENV['subproject']}" : keyboard
end

def call_qmk_firmware(keyboard, keymap, target=nil)
  make_target = "#{keyboard_revision(keyboard)}:#{keymap}"

  if avr_gcc?
    make_target += ":#{target}" if target
    sh "cd #{QMK_PATH} && make #{make_target}"
  else
    if target
      Rake::Task["qmk:deceive"].invoke
      ENV['PATH']  = "#{Dir.pwd}/.bin:#{ENV['PATH']}"
      make_target += ":#{target}"
      sh "cd #{QMK_PATH} && make #{make_target}"
    else
      sh "docker run --rm -v \"#{QMK_PATH}:/qmk:rw\" haruake/qmk_firmware make #{make_target}"
    end
  end
ensure
  Rake::Task["keyboard:#{keyboard}:clean"].invoke
  Rake::Task["qmk:undeceive"].invoke
end

def keyboards()
  Dir.glob("./keyboards/*").map do |path|
    { :name => File.basename(path), :path => path }
  end
end

def keymaps(keyboard)
  Dir.glob("./keyboards/#{keyboard}/keymaps/*").map do |path|
    { :name => File.basename(path), :path => path }
  end
end

task :default => :help
task :help do
  sh 'rake -T', verbose: false
end
