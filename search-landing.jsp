<div>
    <form class="searchForm">
        <div class="search">
            <label> Search: </label>
            <input type="text" ng-model="searchTerm" search-term-dir>
            <input type="submit" class="submit" value="Search" ng-disabled="!searchTerm" load-result-page="/results">
        </div>
    </form>
    <div class="freq-search">
        <span class="text">Frequently searched terms: </span>
        <a href="javascript:void(0);" load-result-page="/results"><span>market</span></a>
    </div>
</div>