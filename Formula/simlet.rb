# typed: strict
# frozen_string_literal: true

class Simlet < Formula
  desc "Agentless iOS/tvOS simulator automation CLI (HID + accessibility)"
  homepage "https://github.com/bitxeno/simlet-cli"

  version "0.2.0"

  if Hardware::CPU.arm?
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.2.0/simlet-0.2.0-darwin-arm64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/623870533",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "53780f26a046f656068040ba473986ec94f24d9af1e0b9224656fe27aaae90f3"
  else
    if ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.empty?
      url "https://github.com/bitxeno/simlet-cli/releases/download/v0.2.0/simlet-0.2.0-darwin-amd64.tar.gz"
    else
      url "https://api.github.com/repos/bitxeno/simlet-cli/releases/assets/623870532",
          headers: [
            "Accept: application/octet-stream",
            "Authorization: Bearer #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}",
          ]
    end
    sha256 "9a7ca560b5b769a168b79902cb5e447b88984221caec27c204bc103a099ba2bd"
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
