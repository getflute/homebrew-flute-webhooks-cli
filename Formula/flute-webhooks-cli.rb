class FluteWebhooksCli < Formula
  desc "Terminal UI and CLI for managing Flute webhook endpoints"
  homepage "https://github.com/getflute/flute-webhooks-cli"
  version "0.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/getflute/flute-webhooks-cli/releases/download/v0.6.0/flute-webhooks-cli-aarch64-apple-darwin.tar.xz"
    sha256 "774debb71120569a5fca6ed9adeb8edc3ee09e182b1aa1054d3f67dc3ed23001"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getflute/flute-webhooks-cli/releases/download/v0.6.0/flute-webhooks-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8d685e48dae85aae9c9c9167acbbb3e79a3dab0222043b7ad29f58dc1b68bffa"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "flute-webhooks" if OS.mac? && Hardware::CPU.arm?
    bin.install "flute-webhooks" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
