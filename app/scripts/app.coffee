angular.module 'CrossoverTest', ["ngRoute", "ngResource"]

angular.module('CrossoverTest').config ($routeProvider) ->
  $routeProvider.when("/", {"templateUrl": "views/test.html", 'controller': "TestCtrl"})
  $routeProvider.otherwise("/")