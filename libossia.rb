class Libossia < Formula
  include Language::Python::Virtualenv
  desc "libossia is a modern C++, cross-environment distributed object model for creative coding."
  homepage "https://ossia.io"
  url "https://github.com/OSSIA/libossia.git"
  head "https://github.com/OSSIA/libossia.git", :revision => "e07bb25c16edd3e11855e4e193a6c39900741f46"
  sha256 ""
  version "1.0.0-b3"
  option "with-python3", "Build Python3 bindings"
  option "with-python", "Build Python bindings"
  option "with-qml", "Build QML binding"
  depends_on :python3 => :optional
  depends_on :python => :optional
  depends_on "boost"
  depends_on "cmake"
  depends_on "qt5"
 
  resource "pyossia" do
    url "https://github.com/PixelStereo/pyossia.git"
    sha256 ""
  end
 
  def install
    system "mkdir", "build"
    Dir.chdir('build')
    system "cmake", "..", '-DOSSIA_PYTHON'
    system "make", "-j8"
    Dir.chdir('..')
    if build.with? "python3"
      # create a symlink in /usr/local/lib/python3.6/site-packages/ossia_python.cpython-36m-darwin.so
      # that refer to the /usr/local/Cellar/libossia/${Version}/lib/python3.6/site-packages/ossia_python.cpython-36m-darwin.so
      (lib+"python3.6/site-packages").install "build/ossia_python.cpython-36m-darwin.so"
    end
    if build.with? "python"
      # create a symlink in /usr/local/lib/python2.7/site-packages/ossia_python.so
      # that refer to the /usr/local/Cellar/libossia/${Version}/lib/python2.7/site-packages/ossia_python.so
      (lib+"python2.7/site-packages").install "build/ossia_python.so"
    end
  end
end