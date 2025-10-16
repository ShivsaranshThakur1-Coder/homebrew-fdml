class Fdml < Formula
  desc "Folk Dance Markup Language CLI"
  homepage "https://shivsaranshthakur1-coder.github.io/fdml-core/"
  url "https://github.com/ShivsaranshThakur1-Coder/fdml-core/releases/download/v0.3.2/fdml-core.jar", using: :nounzip
  version "0.3.2"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"

  depends_on "openjdk@17"

  resource "fdml-xsd" do
    url "https://raw.githubusercontent.com/ShivsaranshThakur1-Coder/fdml-core/v0.3.0/schema/fdml.xsd"
    sha256 "d544d8689faf39bef01f8608a5640d59cd143161f8d116c7866a755dba383167"
  end

  resource "fdml-schematron" do
    url "https://raw.githubusercontent.com/ShivsaranshThakur1-Coder/fdml-core/v0.3.0/schematron/fdml-compiled.xsl"
    sha256 "22cdf4dc66fe13616e6b9028688ed7f5cffae899df3b8456228be682a31bfefe"
  end

  def install
    libexec.install "fdml-core.jar"
    resource("fdml-xsd").stage { (libexec/"schema").install "fdml.xsd" }
    resource("fdml-schematron").stage { (libexec/"schematron").install "fdml-compiled.xsl" }

    (bin/"fdml").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      SOURCE="$0"
      while [ -L "$SOURCE" ]; do
        DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
        TARGET="$(readlink "$SOURCE")"
        case "$TARGET" in /*) SOURCE="$TARGET";; *) SOURCE="$DIR/$TARGET";; esac
      done
      BIN_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
      LIBEXEC="$BIN_DIR/../libexec"
      CALLER_PWD="$(pwd)"
      RES=()
      expect_path_next=""
      for tok in "$@"; do
        if [ "$expect_path_next" = "1" ]; then
          case "$tok" in
            /*) path="$tok" ;;
            ~*) path="${tok/#\~/$HOME}" ;;
            *)  path="$CALLER_PWD/$tok" ;;
          esac
          RES+=("$path")
          expect_path_next=""
          continue
        fi
        case "$tok" in
          --out|--json-out) RES+=("$tok"); expect_path_next="1" ;;
          -*)
            RES+=("$tok")
            ;;
          *)
            if [ -e "$tok" ]; then
              abspath="$(cd "$(dirname "$tok")" && pwd)/$(basename "$tok")"
              RES+=("$abspath")
            else
              RES+=("$tok")
            fi
            ;;
        esac
      done
      cd "$LIBEXEC"
      exec "#{Formula["openjdk@17"].opt_bin}/java" -jar "./fdml-core.jar" "${RES[@]}"
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
