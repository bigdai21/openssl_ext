require "../bio"

class OpenSSL::MemBIO < IO
  def initialize(@bio : LibCrypto::Bio*)
    raise BioError.new "Invalid handle" unless @bio
  end

  def initialize
    initialize LibCrypto.bio_new(LibCrypto.bio_s_mem)
  end

  def read(data : Bytes)
    LibCrypto.bio_read(self, data, data.size)
  end

  def write(data : Bytes) : Nil
    LibCrypto.bio_write(self, data, data.size)
  end

  def reset
    LibCrypto.bio_ctrl(self, LibCrypto::BIO_CTRL_RESET, 0_i64, nil)
  end

  def finalize
    LibCrypto.bio_free_all(self)
  end

  def to_string
    buf = IO::Memory.new
    IO.copy(self, buf)
    buf.to_s
  end

  def to_unsafe
    @bio
  end
end
