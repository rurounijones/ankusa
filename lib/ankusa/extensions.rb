class String
  def to_ascii
    encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "")
  end
end
