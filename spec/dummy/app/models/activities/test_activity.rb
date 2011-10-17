class TestActivity < Activity
  audience :events
  audience :users, :feed => "UserFeed"

  def users
    [actor] + authors
  end

  def events
    []
  end

  def authors
    []
  end
end