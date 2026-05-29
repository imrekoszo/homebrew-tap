class TryAT193 < Formula
  desc "!!- IMRE's OWN FORK OF TRY -!! Quickly manage and navigate project directories for experiments"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "ae1917c7349d3ea41be829b21ef5e4a362e629a923a442d4da525b77cb3117c0"
  license "MIT"
  head "https://github.com/tobi/try.git", branch: "main"

  depends_on "ruby@3"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["BUNDLE_VERSION"] = "system"
    ENV["GEM_HOME"] = libexec

    gem_name = "try-cli"
    system Formula["ruby@3"].opt_bin/"bundle", "install"
    system Formula["ruby@3"].opt_bin/"gem", "build", "#{gem_name}.gemspec"
    system Formula["ruby@3"].opt_bin/"gem", "install", "#{gem_name}-#{version}.gem"

    bin.install libexec/"bin/try" => "#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  def caveats
    <<~EOS
      To set up try with your shell, add one of the following:

      For fish:
        eval (try@1.9.3 init ~/imre/sandbox/tries | string replace '/usr/bin/env ruby' (brew --prefix ruby@3)/bin/ruby | string collect)

      For bash/zsh:
        eval "$(try@1.9.3 init ~/imre/sandbox/tries | sed "s|/usr/bin/env ruby|$(brew --prefix ruby@3)/bin/ruby|g")" # maybe, not sure
    EOS
  end

  test do
    try_dir = "#{Dir.pwd}/src/tries/#{Date.today.iso8601}-tobi-try"
    expected_mkdir_command = "mkdir -p '#{try_dir}'"
    expected_clone_command = "git clone 'https://github.com/tobi/try.git' '#{try_dir}'"
    expected_cd_command = "cd '#{try_dir}'"
    output = shell_output("#{bin}/try exec clone https://github.com/tobi/try.git").chomp
    assert_match expected_mkdir_command, output
    assert_match expected_clone_command, output
    assert_match expected_cd_command, output
  end
end
