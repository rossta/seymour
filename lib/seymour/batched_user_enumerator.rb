class BatchedUserEnumerator
  def initialize(find_in_batches_options)
    @find_in_batches_options = find_in_batches_options
  end
  
  def self.for_ids(ids)
    return [] if ids.empty?
    self.new(:conditions => ['id in (?)', ids])
  end
  
  def each
    User.find_in_batches(@find_in_batches_options) do |users|
      User.send(:with_exclusive_scope) do
        users.each do |user|
          yield user
        end
      end
    end
    self
  end
end
