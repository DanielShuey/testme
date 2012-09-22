module TestMe::Formatter
  class Text
    def log msg
      return msg
    end
  end
end

test TestMe::Formatter::Text
  is? :test[TestMe::Formatter::Text], 'test TestMe::Formatter::Text'
  is? :given[{description: "I format things"}], 'given description: I format things'
  is? :also[{description: "I format things"}], 'also description: I format things'
