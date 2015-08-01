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
    $scope.pagination = {
        page: 1,
        has_next: false,
        has_prev: false
    }

    $scope.load = ->
        $rootScope.loading = true
        $http.get('/api/users?page=' + $scope.pagination.page)
        .success (resp)->
            $rootScope.loading = false
            $scope.users = resp.results
            $scope.total = resp.total
            $scope.pagination.page = resp.page
            $scope.pagination.has_prev = resp.has_prev
            $scope.pagination.has_next = resp.has_next

    $scope.load_pref = ->
        return if $scope.pagination.has_prev == false
        $rootScope.loading = true
        $scope.pagination.page--
        $scope.load()

    $scope.load_next = ->
        return if $scope.pagination.has_next == false
        $rootScope.loading = true
        $scope.pagination.page++
        $scope.load()

    $scope.load()
])

.controller('eventsCtrl', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http)->
    $scope.events = []
    $scope.total = 0
    $scope.pagination = {
        page: 1,
        has_next: false,
        has_prev: false
    }

    $scope.load = ->
            $rootScope.loading = true
            $http.get('/api/events?page='+ $scope.pagination.page)
            .success (resp)->
                $rootScope.loading = false
                $scope.events = resp.results
                $scope.total = resp.total
                $scope.pagination.page = resp.page
                $scope.pagination.has_prev = resp.has_prev
                $scope.pagination.has_next = resp.has_next

    $scope.load_pref = ->
        return if $scope.pagination.has_prev == false
        $rootScope.loading = true
        $scope.pagination.page--
        $scope.load()

    $scope.load_next = ->
        return if $scope.pagination.has_next == false
        $rootScope.loading = true
        $scope.pagination.page++
        $scope.load()

    $scope.load()
])

.controller('remindersCtrl', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http)->
    $scope.reminders = []
    $scope.total = 0
    $scope.pagination = {
        page: 1,
        has_next: false,
        has_prev: false
    }

    $scope.load = ->
        $rootScope.loading = true
        $http.get('/api/reminders?page=' + $scope.pagination.page)
        .success (resp)->
            $rootScope.loading = false
            $scope.reminders = resp.results
            $scope.total = resp.total
            $scope.pagination.page = resp.page
            $scope.pagination.has_prev = resp.has_prev
            $scope.pagination.has_next = resp.has_next

    $scope.load_pref = ->
        return if $scope.pagination.has_prev == false
        $rootScope.loading = true
        $scope.pagination.page--
        $scope.load()

    $scope.load_next = ->
        return if $scope.pagination.has_next == false
        $rootScope.loading = true
        $scope.pagination.page++
        $scope.load()

    $scope.load()
])

.controller('logsCtrl', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http)->
    $scope.logs = []
    $scope.total = 0
    $scope.pagination = {
        page: 1,
        has_next: false,
        has_prev: false
    }

    $scope.load = ->
        $rootScope.loading = true
        $http.get('/api/logs?page=' + $scope.pagination.page)
        .success (resp)->
            $rootScope.loading = false
            $scope.logs = resp.results
            $scope.total = resp.total
            $scope.pagination.page = resp.page
            $scope.pagination.has_prev = resp.has_prev
            $scope.pagination.has_next = resp.has_next

    $scope.load_pref = ->
        return if $scope.pagination.has_prev == false
        $rootScope.loading = true
        $scope.pagination.page--
        $scope.load()

    $scope.load_next = ->
        return if $scope.pagination.has_next == false
        $rootScope.loading = true
        $scope.pagination.page++
        $scope.load()

    $scope.load()
])
