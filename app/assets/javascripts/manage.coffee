# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
angular.module("manager", ['ui.router'])

.config(($stateProvider, $urlRouterProvider)->
    $urlRouterProvider.otherwise '/users'

    $stateProvider
    .state 'users', {url: '/users', controller: 'usersCtrl', templateUrl: 'users.html'}
    .state 'events', {url: '/events', controller: 'eventsCtrl', templateUrl: 'events.html'}
    .state 'reminders', {url: '/reminders', controller: 'remindersCtrl', templateUrl: 'reminders.html'}
    .state 'logs', {url: '/logs', controller: 'logsCtrl', templateUrl: 'logs.html'}
)

.controller('usersCtrl', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http)->
    $scope.users = []
    $scope.total = 0

    $rootScope.loading = true
    $http.get('/api/users')
    .success (resp)->
        $rootScope.loading = false
        $scope.users = resp.results
        $scope.total = resp.total
])

.controller('eventsCtrl', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http)->
    $scope.events = []

    $rootScope.loading = true
    $http.get('/api/events?all=1')
    .success (resp)->
        $rootScope.loading = false
        $scope.events = resp.results
])

.controller('remindersCtrl', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http)->
    $scope.reminders = []

    $rootScope.loading = true
    $http.get('/api/reminders?all=1')
    .success (resp)->
        $rootScope.loading = false
        $scope.reminders = resp.results
])

.controller('logsCtrl', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http)->
    $scope.logs = []
    $scope.total = 0

    $rootScope.loading = true
    $http.get('/api/logs')
    .success (resp)->
        $rootScope.loading = false
        $scope.logs = resp.results
        $scope.total = resp.total
])
