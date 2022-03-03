class Hdf4 < Formula
  desc "Hdf4"
  homepage "https://hdfgroup.org"
  url "https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz"
  sha256 "dbeeef525af7c2d01539906c28953f0fdab7dba603d1bc1ec4a5af60d002c459"

  depends_on "pkg-config" => :build
  depends_on "zlib"
  depends_on "jpeg"
  depends_on "szip"

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-zlib=#{Formula["zlib"].prefix}",
      "--with-jpeg=#{Formula["jpeg"].prefix}",
      "--with-szip=#{Formula["szip"].prefix}",
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
