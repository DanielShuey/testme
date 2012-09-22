test TestMe::Double

 given test: 5
  is? :test, 5

 given { topic.test.test2 = 5 }
  is? { topic.test.test2 == 5 }
