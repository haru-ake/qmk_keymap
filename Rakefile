require 'rake'

QMK_PATH = "#{Dir.pwd}/qmk_firmware"

def qmk_submodule?
  r = `git submodule status`
  $?.success? && !r.empty?
end

def call_qmk_firmware(keyboard, keymap, target=nil)
  if ENV['subproject']
    keyboard_rev = "#{keyboard}/#{ENV['subproject']}"
  else
    keyboard_rev = keyboard
  end

  make_target  = "#{keyboard_rev}:#{keymap}"
  make_target += ":#{target}" if target

  sh "cd #{QMK_PATH} && make #{make_target}"
ensure
  Rake::Task["keyboard:#{keyboard}:clean"].invoke
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
