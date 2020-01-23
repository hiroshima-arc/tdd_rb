# frozen_string_literal: true

require 'cowsay'

Handler =
  proc do |_req, res|
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = Cowsay.say('hello world', 'cow')
  end
