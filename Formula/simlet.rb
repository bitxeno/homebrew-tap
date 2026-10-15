# typed: strict
# frozen_string_literal: true

class Simlet < Formula
  desc "Agentless iOS/tvOS simulator automation CLI (HID + accessibility)"
  homepage "https://github.com/bitxeno/simlet-cli"

  version "0.3.0"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.3.0/simlet-0.3.0-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/644406951",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "3170619d455f5a2eea73d0a7cd4d053f648677d2237c402bf3caa2c9ce048b43"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.3.0/simlet-0.3.0-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/644406953",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "5950b38f4ff47fee8379912c8795d4cab194ad3c6671110504307926493e93c5"
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
