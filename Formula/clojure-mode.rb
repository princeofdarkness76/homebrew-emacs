require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClojureMode < EmacsFormula
  desc "Emacs major mode for Clojure"
  homepage "https://github.com/clojure-emacs/clojure-mode"
  url "https://github.com/clojure-emacs/clojure-mode/archive/5.0.1.tar.gz"
  sha256 "e046f8c2c286c50724c2c11725d0dbc33c3247bc4f5f2e070483b414bacc3dce"
  head "https://github.com/clojure-emacs/clojure-mode.git"

  option "with-inf", "Build with the \"inferior\" REPL"

  depends_on :emacs => "24.3"
  depends_on "cask"

  resource "inf" do
    url "https://github.com/clojure-emacs/inf-clojure/archive/v1.3.0.tar.gz"
    sha256 "adadc2a73a41c9409dcba3a1a2fe37ae3e3e4ec0d3aed2000d30df6d1ff70a93"
  end

  def install
    if build.with? "inf"
      resource("inf").stage do
        byte_compile "inf-clojure.el"
        elisp.install "inf-clojure.el", "inf-clojure.elc"
      end
    end
    system "make", "test", "CASK=#{Formula["cask"].bin}/cask"
    system "make", "compile", "CASK=#{Formula["cask"].bin}/cask"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "clojure-mode")
      (print clojure-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
