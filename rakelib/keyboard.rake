require 'pathname'

namespace :keyboard do
  keyboards.each do |keyboard|
    desc 'compile all keyboards'
    task :all => "keyboard:#{keyboard[:name]}:all"

    keymaps = (keymaps(keyboard[:name]) + QMK_DEFAULT_KEYMAPS).uniq { |i| i[:name] }
    keymaps.each do |keymap|
      namespace keyboard[:name] do
        if keymap[:path]
          desc 'compile all keymaps'
          task :all => "keyboard:#{keyboard[:name]}:#{keymap[:name]}"
        end

        task :clean do
          sh <<~"CMD", verbose: false
            cd #{QMK_PATH}/#{keyboard[:path]} && git clean -fd && git checkout .
          CMD
        end

        task :copy do
          if keymap[:path]
            sh <<~"CMD", verbose: false
              cp -fr #{keymap[:path]} #{Pathname("#{QMK_PATH}/#{keymap[:path]}") + '../'}
            CMD
          end
        end

        desc 'compile firmware' if keymap[:path]
        task keymap[:name].to_sym => :copy do
          call_qmk_firmware(keyboard[:name], keymap[:name])
        end

        namespace keymap[:name].to_sym do
          QMK_MAKE_TARGETS.each do |target|
            desc target[:description] if keymap[:path]
            task target[:name] => "keyboard:#{keyboard[:name]}:copy" do
              call_qmk_firmware(keyboard[:name], keymap[:name], target[:target])
            end
          end

          if keymap[:path] && upload_target(keyboard[:name], keymap[:name])
            desc 'upload firmware'
            task :upload => \
              "keyboard:#{keyboard[:name]}:#{keymap[:name]}:upload:#{upload_target(keyboard[:name], keymap[:name])[:name]}"
          end

          namespace :upload do
            QMK_UPLOAD_TARGETS.each do |target|
              desc target[:description] if keymap[:path] && !upload_target(keyboard[:name], keymap[:name])
              task target[:name] => "keyboard:#{keyboard[:name]}:copy" do
                call_qmk_firmware(keyboard[:name], keymap[:name], target[:name])
              end
            end
          end
        end
      end
    end
  end
end
