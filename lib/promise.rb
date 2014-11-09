require "promise/version"

class Promise

public

  def then(on_success)
    on_success.call
  end

private

  def initialize
    @state = :pending
    begin
      yield method(:fulfill)
    rescue Exception => e
      reject(e)
    end
  end

  def fulfill(value)
    @state = :fulfilled
  end

  def fulfilled?
    @state == :fulfilled
  end

  def pending?
    @state == :pending
  end


  def reject(value)
    @state = :rejected
  end

  def rejected?
    @state == :rejected
  end
end
