 <!DOCTYPE html>
<html lang="en-US">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
<script src="//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-2.5.0.js"></script>
<link href="//netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

<body>
<div ng-app="myApp" ng-controller="ctrl" ng-cloak>
    <div class="searchForm">
        <div class="search">
            <label> Search: </label>
            <input type="text" ng-model="searchTerm" search-term-dir>
            <input type="submit" class="submit" value="Search" ng-disabled="(searchTerm.length > 0) ? false : true" get-result-dir="10">
        </div>
        <div class="filter">
            <label> Filter: </label>
            <input type="text" ng-model="filterTerm">
        </div>
    </div>
    <table>
        <th class='index'> S.No. </th>
        <th class='title' ng-click="sortMe('title')"> Title </th> 
        <th class='summary'> Summary </th>
        <th class='pubdate' ng-click="sortByDate()"> Published Date </th>
        <th class='category' ng-click="sortMe('category')"> Category </th>
        <tr class='result-item' ng-repeat="x in output | filter:filterTerm | orderBy:sortParam:reverse"> 
            <td class='index'> {{$index + 1}} </td>
            <td class='title'> <a ng-href="{{x.path}}.html"> {{ x.title}} </a> </td>
            <td class='summary'> {{ x.summary}} </td>
            <td class='pubdate'> {{ x.pubDate}} </td>
            <td class='category'> {{ x.category}} </td>
            <td ng-hide='true'> {{x.path}} </td>
        </tr>
    </table>
    <div class="pagination">
    	<button get-result-dir> Load More </button>
    </div>
</div>

<script>
var app = angular.module('myApp', ['ui.bootstrap']);

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
                url: '/exampleServlet,
				headers: {
					'CSRF-Token': token
				}
			}).then(function(response){
				deferred.resolve(response.data.results);
			});
		});
		return deferred.promise;
	}
	return {getResults: getResults};
});

app.controller('ctrl', function($scope) {
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

</script> 
</body> 
<style>
    table, th, td {
        border: 1px solid grey;
        border-collapse: collapse;
        padding: 5px;
    }
    table {
        width: 100%;
    }
    table th {
        text-align: center;
    }
    .index {
        width: 3%;
    }
    .title {
        width: 30%;
    }
    .summary {
        width: 50%;
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
</style>
</html> 