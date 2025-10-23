# lib/batch_lock.rb
module BatchLock
  def self.with_file_lock(name, nonblock: true)
    Dir.mkdir(Rails.root.join("tmp/locks")) rescue nil
    path = Rails.root.join("tmp/locks", "#{name}.lock")
    File.open(path, "w") do |f|
      mode = File::LOCK_EX
      mode |= File::LOCK_NB if nonblock
      got = f.flock(mode)   # true/false
      raise "Another job is running: #{name}" unless got
      yield
    ensure
      f.flock(File::LOCK_UN) rescue nil
    end
  end
end
