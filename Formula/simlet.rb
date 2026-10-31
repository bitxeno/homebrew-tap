# typed: strict
# frozen_string_literal: true

class Simlet < Formula
  desc "Agentless iOS/tvOS simulator automation CLI (HID + accessibility)"
  homepage "https://github.com/bitxeno/simlet-cli"

  version "0.3.2"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.3.2/simlet-0.3.2-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/695422115",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "327cfa8590336772446b532dd9b9910bf23b551b70960a731976918a5116d1ba"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.3.2/simlet-0.3.2-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/695422114",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "c487f576f8f3912d88c66d7ce0d685a1b88be619e8041dacf6fa774eaa0667ee"
  end

  # macOS-only: simlet dlopens Xcode's private SimulatorKit and
  # CoreSimulator frameworks in-process.
  depends_on macos: :monterey

  def install
    bin.install "simlet"
  end

  def caveats
    <<~EOS
      simlet drives simulators through Xcode's private frameworks —
      Xcode must be installed, and the target simulator booted.
      Requires macOS 12+; on tvOS only Siri Remote keys and focus
      navigation are supported (no coordinate taps).
    EOS
  end

  test do
    assert_match "simlet", shell_output("#{bin}/simlet --help")
  end
end
