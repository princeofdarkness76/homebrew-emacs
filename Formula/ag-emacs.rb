require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AgEmacs < EmacsFormula
  desc "Emacs front-end to ag (the silver searcher)"
  homepage "http://agel.readthedocs.org/en/latest/"
  url "https://github.com/Wilfred/ag.el/archive/0.46.tar.gz"
  sha256 "27d55776b47968bbccf0548d63bc91ef91390322842ab1f95db6c107d862df93"
  head "https://github.com/Wilfred/ag.el.git"

  depends_on :emacs => "23.4"
  depends_on "the_silver_searcher"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/s"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "ag.el"
    elisp.install "ag.el", "ag.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].opt_elisp}")
      (load "ag")
      (print (buffer-name (ag "#{elisp}" "#{testpath}")))
    EOS
    assert_equal "\"*ag search text:#{elisp} dir:#{testpath}*\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
