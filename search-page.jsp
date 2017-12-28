<!DOCTYPE html>
<html lang="en-US">
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-route.js"></script>
<script src="//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-2.5.0.js"></script>
<link href="//netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<base href='/content/angular/'/>
</head>    
    <body ng-app="myApp" ng-cloak>
        <div class="search-page-link"> <a search-page> Go to Search Page </a></div>
            <div class='ng-view'></div>
            <script>
                var app = angular.module('myApp', ['ngRoute','ui.bootstrap']);
                app.config(function($routeProvider, $locationProvider) {
                    $routeProvider.when('/landing', {
                        templateUrl: 'search-landing.html',
                        controller: 'searchLandingCtrl'
                    }).
                    when('/results', {
                        templateUrl: 'search-results.html',
                        controller: 'searchResultCtrl',
                        resolve: {
                            term : function(searchInputService) {
								return searchInputService.getTerm();
                            } 
                        }
                    }).
                    otherwise({
                        redirectTo: '/landing'
                    });
                    $locationProvider.html5Mode(true);
                });

                app.run(function($rootScope, $timeout) {
                    $rootScope.$on('$routeChangeStart', function(evt, next, current) {
                        $('body').addClass('loading');
                    });
                    $rootScope.$on('$routeChangeSuccess', function(evt, next, current) {
                        $timeout(function() {
							$('body').removeClass('loading');
                        }, 500);
                    });
                });

                app.factory('searchService', function($http, $q){
                    var getToken = function() {
                        var deferred = $q.defer();
                        $http.get('/libs/granite/csrf/token.json').then(function(response) {
                            deferred.resolve(response.data.token);
                        });
                        return deferred.promise;
                    }
                    var getResults = function(term, limit) {
                        var deferred = $q.defer();
                        var promise = getToken();
                        promise.then(function(token) {
                            $http({
                                method: 'GET',
                                url: '/content/dam/angular/data.json',
                            }).then(function(response){
                                deferred.resolve(response.data);
                                $(document).ready(function() {
                                    $('table tr').slice(0, 11).show();
                                }); 
                            });
                        });
                        return deferred.promise;
                    }
                    return {getResults: getResults};
                });

                app.factory('searchInputService', function() {
                    var term, freqTerm;
                    var getTerm = function() {
                        return this.term;
                    }
                    var setTerm = function(queryTerm) {
						this.term = queryTerm;
                    }
                    var getFreqTerm = function() {
                        return this.freqTerm;
                    }
                    var setFreqTerm = function(queryTerm) {
						this.freqTerm = queryTerm;
                    }
                    return {getTerm: getTerm, setTerm: setTerm, getFreqTerm: getFreqTerm, setFreqTerm: setFreqTerm};
                });

                app.controller('searchResultCtrl', function($scope, term) {
                    $scope.searchTerm = term;
                    $scope.reverse = false;
                    $scope.sortMe = function(sortParam) {
                        $scope.sortParam = sortParam;
                        $scope.reverse = !$scope.reverse;
                    }
                    $scope.sortByDate = function() {
                        $scope.reverse = !$scope.reverse;
                        $scope.sortParam = function(x) {
                            return new Date(x.pubDate);
                        }    
                    }
                    $(document).ready(function() {
                        $(".submit").trigger("click");
                    }); 
                });

                app.controller('searchLandingCtrl', function($scope) {

                });

                app.directive('getResultDir', ['searchService', function(searchService) {
                    return {
                        restrict: 'A',
                        link: function($scope, element, attrs) {
                            element.click(function() {
                                var itemsToFetch = (attrs.getResultDir !== '') ? attrs.getResultDir : angular.element('.result-item').length + 10;
                                searchService.getResults($scope.searchTerm, itemsToFetch).then(function(results){
                                    $scope.output = results;
                                });
                            });
                        }
                    }
                }]);
                
                app.directive('searchTermDir', function() {
                    return {
                        restrict: 'A',
                        link: function($scope, element, attrs) {
                            element.focus();
                        }
                    }
                });
                app.directive('searchPage', function() {
                    return {
                        restrict: 'A',
                        link: function($scope, element, attrs) {
                            element.click(function() {
                                window.location.href = "/content/angular/search-page.html";
                            });
                        }
                    }
                });
                app.directive('loadResultPage', ['$location', 'searchInputService',
                                                 function($location, searchInputService) {
                    return {
                        restrict: 'A',
                        link: function(scope, element, attrs) {
                            element.click(function() {
                                var term = scope.searchTerm;
                                if(term === undefined) {
									term = element.get(0).text;
                                }
                                searchInputService.setTerm(term);
                                searchInputService.setFreqTerm(term);
								scope.$apply(function() {
	                                $location.path(attrs.loadResultPage);
                                });
                            });
                        }
                    }
                }]);

                app.directive('loadMoreDir', function() {
                    return {
                        restrict: 'A',
                        link: function(scope, element, attrs) {
                            element.click(function() {
                                var startCount = $('table tr').not(':hidden').length;
                                var endCount = startCount + 10;
								$('table tr').slice(startCount, endCount).show();
                            });
                        }
                    }
                });

            </script>
        <div class="loader-modal"></div>
    </body>
    <style>
        .search-page-link {
			font-size: 25px;
            margin: 10px;
            text-align: center;
        }
        .search-page-link a:hover {
            cursor: pointer;
        }
        table, th, td {
            border: 1px solid grey;
            border-collapse: collapse;
            padding: 5px;
        }
        table {
            width: 100%;
        }
        table tr {
            display: none;
        }
        table th, table td {
            text-align: center;
        }
        .index {
            width: 3%;
        }
        .title {
            width: 15%;
        }
        .summary {
            width: 45%;
        }
        .pubdate {
            width: 10%;
        }
        .category {
            width: 7%;
        }
        .pagination {
            text-align: center;
            padding: 10px;
            display: inherit;
        }
        .searchForm {
            display: table;
            padding: 10px;
        }
        .searchForm .search {
            display: table-cell;
            width: 75%;
            text-align: center;
        }
        .searchForm input {
            width: 250px;
        }
        .searchForm input.submit {
            width: 100px;
        }
        .loader-modal {
            display:    none;
            position:   fixed;
            z-index:    10000;
            top:        0;
            left:       0;
            height:     100%;
            width:      100%;
            background: rgba( 255, 255, 255, .8 ) 
                        url('https://i.stack.imgur.com/FhHRx.gif') 
                        50% 50% 
                        no-repeat;
        }
        
        body.loading {
            overflow: hidden;   
        }
        
        body.loading .loader-modal {
            display: block;
        }
        .freq-search {
            margin: 30px 80px;
        }
		.freq-search .text {
			font-weight: bold;
		}
    </style>
</html>