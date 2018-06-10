namespace :qmk do
  desc 'initialize qmk_firmware'
  task :init do
    unless qmk_submodule?
      sh 'git submodule add https://github.com/qmk/qmk_firmware.git'
    end
    sh 'git submodule update --init --recursive'
    sh 'mkdir -p ./keyboards', verbose: false
  end

  desc 'remove all untracked files in qmk_firmware'
  task :clean do
    sh <<~"CMD"
      cd #{QMK_PATH} && git clean -fdx && git checkout .
    CMD
  end

  desc 'revert qmk_firmware and nested submodules to local HEAD'
  task :revert => "qmk:init"

  desc 'update qmk_firmware to latest commit on upstream'
  task :update do
    sh <<~"CMD"
      git submodule update --recursive --remote
      git submodule foreach git submodule sync --recursive
      git submodule foreach git submodule update --init --recursive
    CMD
  end
end
