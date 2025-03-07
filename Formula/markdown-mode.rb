require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MarkdownMode < EmacsFormula
  desc "Major mode for editing Markdown files"
  homepage "http://jblevins.org/projects/markdown-mode/"
  url "https://github.com/jrblevin/markdown-mode/archive/v2.1.tar.gz"
  sha256 "65d28802915a47056108b63eba3911e32de35c5d6b3c6898ca23ac414b0c4de7"
  head "https://github.com/jrblevin/markdown-mode.git"

  deprecated_option "with-markdown-plus" => "with-plus"

  option "with-plus", "Install the markdown-mode+ extension"
  option "with-toc", "Install the markdown-toc extension"

  depends_on :emacs

  if build.with? "toc"
    depends_on "homebrew/emacs/s"
    depends_on "homebrew/emacs/dash-emacs"
  end

  resource "markdown+" do
    url "https://github.com/milkypostman/markdown-mode-plus/raw/f35e63284c5caed19b29501730e134018a78e441/markdown-mode%2B.el"
    sha256 "743209cb390f9bd29bbaaf53d8e4940ee452ce401d85f253d938503d0e80d0f8"
  end

  resource "markdown-toc" do
    url "https://github.com/ardumont/markdown-toc/releases/download/0.0.8/markdown-toc-0.0.8.tar"
    sha256 "41369e5e2715672ead1570714c3f3aedce2e8c754b817b78c521405bf0349639"
  end

  def install
    if build.with? "plus"
      resource("markdown+").stage do
        mv "markdown-mode%2B.el", "markdown-mode+.el"
        byte_compile "markdown-mode+.el"
        elisp.install "markdown-mode+.el", "markdown-mode+.elc"
      end
    end
    if build.with? "toc"
      resource("markdown-toc").stage do
        byte_compile "markdown-toc.el"
        elisp.install "markdown-toc.el", "markdown-toc.elc"
      end
    end

    # Install markdown-mode last so it's in the buildpath when
    # markdown-toc looks for it during compile
    byte_compile "markdown-mode.el"
    elisp.install "markdown-mode.el", "markdown-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (require 'markdown-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
