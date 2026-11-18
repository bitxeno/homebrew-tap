# typed: strict
# frozen_string_literal: true

cask "atvloadly" do
  version "0.8.5"
  sha256 "87397e29a632ba3b7b2c3afcff8b8f06c0f07b9b0411ea838c3d9fa2d328aa11"

  url "https://github.com/bitxeno/atvloadly/releases/download/v0.8.5/atvloadly-0.8.5.dmg"
  name "atvloadly"
  desc "Sideload apps onto Apple TV devices"
  homepage "https://github.com/bitxeno/atvloadly"

  depends_on :macos

  app "atvloadly.app"

  # The build is not notarized (ad-hoc signing): strip quarantine
  # right after install to avoid the first-launch Gatekeeper block,
  # and restore the exec bit on the bundled plumesign engine under
  # Resources/bin. Users downloading the DMG directly do not go
  # through this path; caveats keeps the manual instructions.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/atvloadly.app"]
    set_permissions "{{appdir}}/atvloadly.app/Contents/Resources/bin/plumesign", "0755"
  end

  caveats <<~EOS
    The build is not notarized (ad-hoc signing). If Gatekeeper
    blocks the first launch: right-click the app and choose Open,
    or run
      xattr -dr com.apple.quarantine /Applications/atvloadly.app
  EOS
end
