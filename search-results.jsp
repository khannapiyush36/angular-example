<div>
    <div class="searchForm">
        <div class="search">
            <label> Search: </label>
            <input type="text" ng-model="searchTerm" search-term-dir>
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
        <th class='pubdate' ng-click="sortByDate()"> Email </th>
        <th class='summary'> About </th>
        <th class='category' ng-click="sortMe('category')"> Company </th>
        <tr class='result-item' ng-repeat="x in output | filter:filterTerm | orderBy:sortParam:reverse"> 
            <td class='index'> {{$index + 1}} </td>
            <td class='title'> {{x.name}} </td>
            <td class='pubdate'> <a ng-href="mailto:{{x.email}}"> {{ x.email}} </a> </td>
            <td class='summary'> {{ x.about}} </td>
            <td class='category'> {{ x.company}} </td>
        </tr>
    </table>
    <div class="pagination">
    	<button load-more-dir> Load More </button>
    </div>
</div>
