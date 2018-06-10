require 'pathname'

QMK_MAKE_TARGETS = [
  { :name => 'avrdude',  :description => 'upload firmware using avrdude' },
  { :name => 'dfu',      :description => 'upload firmware using dfu' },
  { :name => 'dfu-util', :description => 'upload firmware using dfu-uti' },
  { :name => 'teensy',   :description => 'upload firmware using teensy' },
  { :name => 'clean',    :description => 'cleans the build output files' }
]

namespace :keyboard do
  keyboards.each do |keyboard|
    desc 'compile all keyboards'
    task :all => "keyboard:#{keyboard[:name]}:all"

    keymaps(keyboard[:name]).each do |keymap|
      namespace keyboard[:name] do
        desc 'compile all keymaps'
        task :all => "keyboard:#{keyboard[:name]}:#{keymap[:name]}"

        task :clean do
          sh <<~"CMD", verbose: false
            cd #{QMK_PATH}/#{keyboard[:path]} && git clean -fd && git checkout .
          CMD
        end

        task :copy do
          sh <<~"CMD", verbose: false
            cp -fr #{keymap[:path]} #{Pathname("#{QMK_PATH}/#{keymap[:path]}") + '../'}
          CMD
        end

        desc 'compile firmware'
        task keymap[:name].to_sym => :copy do
          call_qmk_firmware(keyboard[:name], keymap[:name])
        end

        namespace keymap[:name].to_sym do
          QMK_MAKE_TARGETS.each do |target|
            desc target[:description]
            task target[:name] => "keyboard:#{keyboard[:name]}:copy" do
              call_qmk_firmware(keyboard[:name], keymap[:name], target[:name])
            end
          end
        end
      end
    end
  end
end
