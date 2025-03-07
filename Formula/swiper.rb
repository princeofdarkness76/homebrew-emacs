require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Swiper < EmacsFormula
  desc "Emacs isearch with an overview"
  homepage "https://github.com/abo-abo/swiper"
  url "https://github.com/abo-abo/swiper/archive/0.7.0.tar.gz"
  sha256 "8e25761d466edff701c09f5c245903597493bac72dedfef84a1ba6eaf0cbd3ef"
  head "https://github.com/abo-abo/swiper.git"

  option "with-helm", "Use helm as the backend instead of ivy"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/helm" if build.with? "helm"

  resource "swiper-helm" do
    url "https://github.com/abo-abo/swiper-helm/archive/0.1.0.tar.gz"
    sha256 "8db4b0d7835cd71f17ae7fcc2642208270b332c38cc06f44fca5f7b3e674d8ab"
  end

  def install
    if build.with? "helm"
      resource("swiper-helm").stage do
        byte_compile "swiper-helm.el"
        elisp.install "swiper-helm.el", "swiper-helm.elc"
      end
    end

    system "make", "compile"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "swiper")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
