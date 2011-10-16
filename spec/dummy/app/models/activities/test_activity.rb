class TestActivity < Activity
  audience :events
  audience :authors, :class_name => "User"

  def events
    []
  end

  def authors
    []
  end
end