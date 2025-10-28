class Fdml < Formula
  desc "Folk Dance Markup Language CLI"
  homepage "https://shivsaranshthakur1-coder.github.io/fdml-core/"
  url "https://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jarURLhttps://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jar", using: :nounzip
  version "https://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jarVERhttps://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jar"
  sha256 "https://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jarSHAhttps://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jar"

  depends_on "openjdkhttps://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jar17"

  def install
    libexec.install "fdml-core.jar"
    (bin/"fdml").write <<~EOS
      #!/usr/bin/env bash
      exec "#{Formula["openjdkhttps://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jar17"].opt_bin}/java" -jar "#{libexec}/fdml-core.jar" "$https://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.4/fdml-core.jar"
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
