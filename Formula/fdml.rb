class Fdml < Formula
  desc "Folk Dance Markup Language CLI"
  homepage "https://shivsaranshthakur1-coder.github.io/fdml-core/"
  url "https://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.0/fdml-core.jar", using: :nounzip
  version "0.3.0"
  sha256 "#{JARSHA}"
  license "MIT"
  revision 1

  depends_on "openjdk@17"

  resource "fdml-src" do
    url "https://github.com/ShivsaranshThakur1-Coder/fdml-core/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "#{TARSHA}"
  end

  def install
    libexec.install "fdml-core.jar"
    resource("fdml-src").stage do
      libexec.install "schema" if Dir.exist?("schema")
      libexec.install "schematron" if Dir.exist?("schematron")
      libexec.install "xslt" if Dir.exist?("xslt")
      libexec.install "docs/css" => "css" if Dir.exist?("docs/css")
      libexec.install "docs/site.css" if File.exist?("docs/site.css")
    end
    (bin/"fdml").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      cd "#{libexec}"
      exec "#{Formula["openjdk@17"].opt_bin}/java" -jar "#{libexec}/fdml-core.jar" ""
    EOS
    chmod 0555, bin/"fdml"
  end

  test do
    (testpath/"t.fdml.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <fdml version="1.0">
        <meta><title>t</title></meta>
        <body><section id="s-1">ok</section></body>
      </fdml>
    XML
    system "#{bin}/fdml", "validate", testpath/"t.fdml.xml"
  end
end
