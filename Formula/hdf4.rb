class Hdf4 < Formula
  desc "Hdf4"
  homepage "https://hdfgroup.org"
  url "https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.16-2/src/hdf-4.2.16-2.tar"
  sha256 "82aa589eb328ff4e7c4644d72bcae4718eb3e840a73740230da4994ff2f47688"
  head "https://github.com/hdfeos/hdf4.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "zlib"
  depends_on "jpeg"

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-zlib=#{Formula["zlib"].prefix}",
      "--with-jpeg=#{Formula["jpeg"].prefix}",
      "--disable-netcdf",
      "--disable-fortran",
      "--enable-hdf4-xdr",
    ]

    system "./configure", *args
    system "make", "install"

    # Remove stray nc* artifacts which conflict with NetCDF.
    rm (bin+"ncdump")
    rm (bin+"ncgen")
  end

  def caveats
    <<~EOS
      HDF4 has been superseeded by HDF5.  However, the API changed
      substantially and some programs still require the HDF4 libraries in order
      to function.
    EOS
  end
end
