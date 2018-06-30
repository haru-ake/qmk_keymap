require 'rake'

QMK_PATH = "#{Dir.pwd}/qmk_firmware"
QMK_DEFAULT_KEYMAPS = [
  { :name => 'default', :path => nil }
]
QMK_MAKE_TARGETS = [
  { :name        => 'clean',
    :description => 'clean compiled firmware',
    :target      => 'clean'
  },
  { :name        => 'qmk_dfu',
    :description => 'compile firmware by qmk-dfu',
    :target      => 'production'
  }
]
QMK_UPLOAD_TARGETS = [
  { :name        => 'avrdude',
    :description => 'upload firmware using avrdude',
    :target      => 'avrdude'
  },
  { :name        => 'dfu',
    :description => 'upload firmware using dfu',
    :target      => 'dfu'
  },
  { :name        => 'dfu-util',
    :description => 'upload firmware using dfu-uti',
    :target      => 'dfu-util'
  },
  { :name        => 'program',
    :description => 'upload firmware using program',
    :target      => 'program'
  },
  { :name        => 'teensy',
    :description => 'upload firmware using teensy',
    :target      => 'teensy'
  }
]

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

def upload_target(keyboard, keymap=nil)
  paths = ["./keyboards/#{keyboard}/.target"]
  paths.unshift("./keyboards/#{keyboard}/keymaps/#{keymap}/.target") if keymap

  target = nil
  paths.each do |path|
    begin
      _t = File.read(path).strip
      target = QMK_UPLOAD_TARGETS.find { |h| h[:name] == _t }
      break if target
    rescue
      next
    end
  end

  target
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
