class Hdf4 < Formula
  desc "Hdf4"
  homepage "https://hdfgroup.org"
  url "https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz"
  sha256 "623662e70285f0d63e58452dbbf14b3c34507ced60f44cdd868c49121eaf13cf"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "szip" => :recommended

  def install
    ENV.O0 # Per the release notes, -O2 can cause memory corruption
    ENV["SZIP_INSTALL"] = HOMEBREW_PREFIX

    args = std_cmake_args
    args.concat [
      "-DBUILD_SHARED_LIBS=ON",
      "-DBUILD_TESTING=OFF",
      "-DHDF4_BUILD_TOOLS=ON",
      "-DHDF4_BUILD_UTILS=ON",
      "-DHDF4_BUILD_WITH_INSTALL_NAME=ON",
      "-DHDF4_ENABLE_JPEG_LIB_SUPPORT=ON",
      "-DHDF4_ENABLE_NETCDF=OFF", # Conflict. Just install NetCDF for this.
      "-DHDF4_ENABLE_SZIP_ENCODING=ON",
      "-DHDF4_ENABLE_SZIP_SUPPORT=ON",
      "-DHDF4_ENABLE_Z_LIB_SUPPORT=ON",
      "-DHDF4_BUILD_FORTRAN=OFF"
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      system "make", "test" if build.with? "tests"

      # Remove stray nc* artifacts which conflict with NetCDF.
      rm (bin+"ncdump")
      rm (bin+"ncgen")
      #      rm (include+"netcdf.inc")
    end
  end

  def caveats
    <<~EOS
      HDF4 has been superseeded by HDF5.  However, the API changed
      substantially and some programs still require the HDF4 libraries in order
      to function.
    EOS
  end
end
