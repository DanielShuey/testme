class TestObject
  def hello; return 'hello'; end
  def world; return 'world'; end
end

test TestMe::Double
 given test: 5
  is? :test, 5

 #Stub chain
 given { topic.test.test2 = 5 }
  is? { topic.test.test2 == 5 }

 #Stub chain over object
 given test: TestMe::Double.new(TestObject.new)
  also { topic.test.test2 = 5 }
   is? { topic.test.test2 == 5 }
