angular.module("CrossoverTest")
  .controller "TestCtrl", ($scope, $http) ->
    $scope.chars =
      "power": ["Мощность (л.с)", "л.c."]
      "momentum": ["Крутящий момент( Н*м)", "Н*м"]
      "time-to-hundred": ["Время разгона до 100км/ч (с)", "c."]
      "consumption": ["Расход топлива на 100км (л)", "л."]
      "max-speed": ["Mаксимальная скорость (км/ч)", "км/ч"]
      "max-weight": ["Cнаряженная масса (кг)", "кг"]
      "engine-volume": ["Объем двигателя (л)", "л."]
      "gas-volume": ["Емкость топливного бака (л)", "л."]
      "clearance": ["Клиренс (мм)", "мм."]
      "storage-volume": ["Объем багажника(л)", "л."]
      
    checkPairs = (target_pair, pairs) ->
      for pair in pairs
        if target_pair[0] in pair and target_pair[1] in pair
          return true
      return false
    
    $scope.rankedResults = {}
    $scope.results = []
    for key, v of $scope.chars
      $scope.rankedResults[key] = {"name": key, "count": 0}
      
    shuffle = (array) ->
      currentIndex = array.length
      temporaryValue = undefined
      randomIndex = undefined
      # While there remain elements to shuffle...
      while 0 != currentIndex
        # Pick a remaining element...
        randomIndex = Math.floor(Math.random() * currentIndex)
        currentIndex -= 1
        # And swap it with the current element.
        temporaryValue = array[currentIndex]
        array[currentIndex] = array[randomIndex]
        array[randomIndex] = temporaryValue
      array
  
    formPairs = (set) ->
      pairs = []
      for key, v of set
        for skey, v2 of set
          if key != skey
            if not checkPairs([key, skey], pairs)
              pairs.push([key, skey])
      return shuffle(pairs)
    
    rateCars = () ->
      ratedCars = {}
      ratedCarIDs = []
      for car in $scope.cars
        rating = {}
        for key, v of $scope.rankedResults
          if $scope.rankedResults[key]['rawPercent']
            rating[key] = $scope.rankedResults[key]['rawPercent'] * car['chars'][key]['value']
        total = 0
        console.log rating
        for key, v of rating
          total += rating[key]
        ratedCars[total] = car
        ratedCarIDs.push(total)
      ratedCarIDs.sort().reverse()
      console.log ratedCarIDs
      bestCar = ratedCars[ratedCarIDs[0]]
      chars = []
      for key, v of bestCar.chars
        v['name'] = key
        chars.push(v)
      bestCar.chars = chars
      bestCar
        
    
    $scope.change = (results) ->
      if $scope.position.current < $scope.position.max-1
        $scope.position.current += 1
        $scope.position.currentP = Math.round(($scope.position.current / ($scope.position.max-1))*100)
        console.log $scope.position.currentP
      if $scope.position.current == $scope.position.max-1
        $scope.position.hide = true
        $scope.bestCar = rateCars()
        console.log $scope.bestCar
      for key, v of $scope.chars
        $scope.rankedResults[key] = {"name": key, "count": 0, "percent": 0}
      for result in results
        if result != undefined
          $scope.rankedResults[result]['count'] += 1
          $scope.rankedResults[result]['rawPercent'] = ($scope.rankedResults[result]['count'] / $scope.pairs.length)
          $scope.rankedResults[result]['percent'] = Math.round($scope.rankedResults[result]['rawPercent'] * 100)
    
    $scope.$watch "pairs", (pairs) ->
      $scope.position = {
        current: 0,
        max: pairs.length
      }
      
    $http.get("json/cars.json").success (cars) ->
      $scope.cars = cars
    init = () ->
      $scope.pairs = formPairs($scope.chars)
      for key, v of $scope.chars
        $scope.rankedResults[key] = {"name": key, "count": 0, "percent": 0}
        $scope.bestCar = undefined
    init()
