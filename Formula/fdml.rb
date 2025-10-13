class Fdml < Formula
  desc "Folk Dance Markup Language CLI"
  homepage "https://shivsaranshthakur1-coder.github.io/fdml-core/"
  url "https://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.0/fdml-core.jar", using: :nounzip
  version "0.3.0"
  sha256 "7281324056e57970c9d10815f148ef8738e4b6a1a39b7a90fa287bb2ac6d7cb1"

  depends_on "openjdk@17"

  def install
    libexec.install "fdml-core.jar"
    (bin/"fdml").write <<~EOS
      #!/usr/bin/env bash
      exec "#{Formula["openjdk@17"].opt_bin}/java" -jar "#{libexec}/fdml-core.jar" "$@"
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
