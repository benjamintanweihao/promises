require 'promise'
# Basic
Promise.new{ p 'Hello' }
Promise.new{ sleep 2; p 'Hello' }
Promise.new { raise 'I raised an EXCEPTION!' }
Promise.new { sleep 2; raise 'I raised an EXCEPTION!' }

# fulfill & reject
Promise.new { |fulfill| sleep 2; fulfill.call('I slept 2 and fulfilled!') }
Promise.new { |_, reject| sleep 2; reject.call('I slept 2 and rejected...') }

Promise.new { raise 'I raised an EXCEPTION!' }.then(_, ->(error){ p error.message } )

on_success = ->(x) { x + 'succeed...' }
on_error = ->(x) { x + 'error...' }
Promise.fulfilled('Start...').then(on_success, on_error).then(on_error, on_success)
Promise.rejected('Start...').then(on_success, on_error).then(on_error, on_success)

# All
memes = %w(Cat Pug Baby)
promises = memes.map do |meme|
  Promise.new { |fulfill, _|
    x = rand(10)
    sleep x; fulfill.call("#{meme} slept #{x}, ")
  }.then(->(y) { msg = y + 'then woke up.' })
end
while true do
  values = promises.map(&:value)
  print "#{values}\r"
  break if values.compact.size == promises.size
end

all_promise = Promise.all(*promises).then(->(x) { p "Everyone is up: #{x}"})
while true do; print "#{all_promise.value}\r"; end

  # Any
def race
  memes = %w(Cat Pug Baby)

  promises = memes.map { |meme|
    Promise.new do |fulfill, reject|
      x = rand(5)
      sleep x; fulfill.call("#{meme} slept #{x}, ")
    end
  } << Promise.new { sleep 3; raise 'Took too long!' }
  Promise.any(*promises).then(->(val) { puts val })
  nil
end

