class TestActivity < Activity
  audience :events
  audience :authors, :feed => "UserFeed"

  def events
    []
  end

  def authors
    []
  end
end