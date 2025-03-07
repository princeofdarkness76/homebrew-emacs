require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HaskellMode < EmacsFormula
  desc "Emacs major mode for Haskell"
  homepage "https://github.com/haskell/haskell-mode"
  url "https://github.com/haskell/haskell-mode/archive/v13.16.tar.gz"
  sha256 "6a846e9fb0b4ba354d6d42452cf298d548a0457271cd73fb792c0bf677a13d59"
  head "https://github.com/haskell/haskell-mode.git"

  deprecated_option "with-html" => "with-docs"
  option "with-docs", "Build HTML documentation"

  depends_on :emacs => "23.1"
  depends_on "texinfo" if build.with? "docs"

  def install
    system "make"
    system "make", "check"
    elisp.install Dir["*.el"], Dir["*.elc"]
    info.install Dir["*.info"]

    if build.with? "docs"
      system "make", "doc/html"
      doc.install "doc/html"
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/haskell-mode")
      (load "haskell-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
