class Libossia < Formula
  include Language::Python::Virtualenv
  desc "libossia is a modern C++, cross-environment distributed object model for creative coding."
  homepage "https://ossia.io"
  url "https://github.com/OSSIA/libossia.git"
  head "https://github.com/OSSIA/libossia.git"
  version "1.0.0-b6"
  option "with-python3", "Build Python3 bindings"
  option "with-python", "Build Python bindings"
  option "with-qml", "Build QML binding"
  depends_on :python3 => :optional
  depends_on :python => :optional
  depends_on "boost"
  depends_on "cmake"
 
  resource "pyossia" do
    url "https://github.com/PixelStereo/pyossia.git"
    sha256 ""
  end
 
  def install
    system "mkdir", "build"
    Dir.chdir('build')
    args = %W[
      -DOSSIA_MAX=0
      -DOSSIA_STATIC=1
      -DCMAKE_BUILD_TYPE=Release
      -DOSSIA_SANITIZE=1
      -DOSSIA_TESTING=0
      -DOSSIA_EXAMPLES=0
      -DOSSIA_CI=0
      -DOSSIA_PD=0
      -DOSSIA_QT=0
      -DOSSIA_QML=0
      -DOSSIA_PYTHON=0
    ]

    args << "-DOSSIA_PYTHON=1" if build.with? "python"
    args << "-DPYTHON_EXECUTABLE=/usr/local/bin/python2 -DPYTHON_LIBRARY=/usr/local/opt/python/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib" if build.with? "python"
    args << "-DPYTHON_EXECUTABLE=/usr/local/bin/python3 -DPYTHON_LIBRARY=/usr/local/opt/python/Frameworks/Python.framework/Versions/3.6/lib/libpython3.6.dylib" if build.with? "python"
    args << "-DCMAKE_INSTALL_PREFIX=~/Downloads" if build.with? "python"
    args << "-DOSSIA_PYTHON=1" if build.with? "python3"
    args << "-DOSSIA_PYTHON=1" if build.with? "python3"
    args << "-DOSSIA_QML=1" if build.with? "qml"
    system "cmake", "..", *args
    system "make", "-j8"

    if build.with? "python3"
      # create a symlink in /usr/local/lib/python3.6/site-packages/ossia_python.cpython-36m-darwin.so
      # that refer to the /usr/local/Cellar/libossia/${Version}/lib/python3.6/site-packages/ossia_python.cpython-36m-darwin.so
      (lib+"python3.6/site-packages").install "build/OSSIA/ossia_python/dist/pyossia.*.wheel"
    end
    if build.with? "python"
      # create a symlink in /usr/local/lib/python2.7/site-packages/ossia_python.so
      # that refer to the /usr/local/Cellar/libossia/${Version}/lib/python2.7/site-packages/ossia_python.so
      (lib+"python2.7/site-packages").install "build/OSSIA/ossia_python/dist/pyossia.*.wheel"
    end
    system "make", "install"
    Dir.chdir('..')
  end
end