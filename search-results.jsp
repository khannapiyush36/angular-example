<div>
    <div class="searchForm">
        <div class="search">
            <label> Search: </label>
            <input type="text" ng-model="searchTerm" search-term-dir>
            <input type="hidden" ng-model="rowsToBeShown">
            <input type="submit" class="submit" value="Search" ng-disabled="!searchTerm" get-result-dir="10">
        </div>
        <div class="filter">
            <label> Filter: </label>
            <input type="text" ng-model="filterTerm">
        </div>
    </div>
    <table>
        <th class='index'> S.No. </th>
        <th class='title' ng-click="sortMe('name')"> Name </th> 
        <th class='pubdate' ng-click="sortMe('email')"> Email </th>
        <th class='summary'> About </th>
        <th class='category' ng-click="sortMe('company')"> Company </th>
        <tr class='result-item' ng-repeat="x in output | filter:filterTerm | orderBy:sortParam:reverse"> 
            <td class='index' ng-hide="hide($index)"> {{$index + 1}} </td>
            <td class='title' ng-hide="hide($index)"> {{x.name}} </td>
            <td class='pubdate' ng-hide="hide($index)"> <a ng-href="mailto:{{x.email}}"> {{ x.email}} </a> </td>
            <td class='summary' ng-hide="hide($index)"> {{ x.about}} </td>
            <td class='category' ng-hide="hide($index)"> {{ x.company}} </td>
        </tr>
    </table>
    <div class="pagination">
    	<button load-more-dir> Load More </button>
    </div>
</div>
